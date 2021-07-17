# frozen_string_literal: true

require File.expand_path('../../spec_helper', __dir__)

describe RdbTaskboard do
  fixtures %i[
    enabled_modules
    issue_statuses
    projects
    projects_trackers
    trackers
    workflows
  ]

  subject(:dashboard) { RdbTaskboard.new(project, options, params) }

  let(:project) { Project.find(1) }
  let(:options) { {} }
  let(:params) { {} }

  describe '#statuses' do
    subject(:statuses) { dashboard.statuses }

    before do
      # Delete all workflow rules related to status 6 (Rejected). We will test,
      # that this now unused issue status does not appear on the board.
      WorkflowTransition.where('new_status_id = :id OR old_status_id = :id', id: 6).delete_all
    end

    it 'returns only issues statuses available in the project' do
      expect(statuses.map(&:id)).to eq [1, 2, 3, 4, 5]
    end
  end
end
