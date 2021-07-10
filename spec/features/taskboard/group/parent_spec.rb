# frozen_string_literal: true

require 'spec_helper'

describe 'Taskboard: Group issues by Parent Task', js: true do
  fixtures %i[
    enumerations
    issue_categories
    issue_statuses
    issues
    member_roles
    members
    projects_trackers
    projects
    roles
    time_entries
    users
    versions
    workflows
    rdb/parent_issues
  ]

  let(:project) { Project.find 'ecookbook' }

  before do
    set_permissions
    project.enable_module! :dashboard
    login_as_admin

    visit '/projects/ecookbook'
    click_on 'Dashboard'

    unset_all_filter
  end

  it 'should group issues' do
    open_menu(:view) do
      click_on 'Parent Task'
    end

    within('[data-rdb-group-id=issue-100]') do
      expect(page).to have_content 'Child #1'
      expect(page).to have_content 'Child #2'
    end
  end
end
