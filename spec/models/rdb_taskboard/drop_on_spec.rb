# frozen_string_literal: true

require File.expand_path('../../spec_helper', __dir__)

describe RdbTaskboard do
  fixtures %i[
    enabled_modules
    issue_statuses
    issues
    member_roles
    members
    projects
    projects_trackers
    roles
    trackers
    users
    workflows
  ]

  subject(:board) { RdbTaskboard.new(project, options, params) }

  let(:project) { Project.find(1) }
  let(:options) { {} }
  let(:params) { {} }
  let(:issue) { Issue.first }
  let(:user) { nil }

  before {
    board.build
    User.current = user
  }

  describe '#drop_on' do
    subject(:columns) { board.drop_on(issue) }

    context 'administrator' do
      let(:user) { User.find_by!(login: 'admin') }

      it 'returns all columns' do
        expect(columns).to eq 's2 s3 s4 sX'
      end
    end

    context 'project manager' do
      let(:user) { User.find_by!(login: 'dlopper') }

      it 'returns only available columns' do
        expect(columns).to eq 's2 s3 s4 sX'
      end
    end

    context 'issue author with only :edit_own_issues' do
      let(:role) do
        Role.new(
          name: 'Test Role',
          permissions: [:edit_own_issues],
        )
      end

      let(:user) { issue.author } # author: jsmith

      before do
        # Issue author must only have permission to edit own issues and
        # a limited workflow:
        issue.project.members.where(user: user).first.roles = [role]

        WorkflowTransition.create!(
          role: role,
          tracker: issue.tracker,
          old_status: issue.status,
          new_status: IssueStatus.find(4),
        )

        WorkflowTransition.create!(
          role: role,
          tracker: issue.tracker,
          old_status: issue.status,
          new_status: IssueStatus.find(5),
        )
      end

      it 'returns only available columns' do
        expect(columns).to eq 's4 sX'
      end
    end

    context 'user with transitions but without permission' do
      let(:user) { User.find_by!(login: 'dlopper') }

      before do
        # User must have role assigned but role must not have :edit_issues permission
        issue.project.members.where(user: user).first.roles.first.update!(permissions: [])
      end

      it 'returns no columns' do
        expect(columns).to be_blank
      end
    end
  end
end
