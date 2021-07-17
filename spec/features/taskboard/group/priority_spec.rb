# frozen_string_literal: true

require 'spec_helper'

describe 'Taskboard: Group issues by Priority', js: true do
  fixtures %i[
    enabled_modules
    enumerations
    issue_categories
    issue_statuses
    issues
    member_roles
    members
    projects
    projects_trackers
    roles
    time_entries
    trackers
    users
    versions
    workflows
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
      click_on 'Priority'
    end

    within('[data-rdb-group-id=priority-2]') do
      expect(page).to have_content 'Issue due today'
    end

    within('[data-rdb-group-id=priority-1]') do
      expect(page).to have_content 'Cannot print recipes'
    end
  end
end
