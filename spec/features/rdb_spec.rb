# frozen_string_literal: true

require File.expand_path('../spec_helper', __dir__)

describe 'Rdb', js: true, sauce: true do
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
    project.enable_module! 'dashboard'
    login_as 'dlopper', 'foo'
  end

  it 'should redirect to taskboard' do
    visit '/projects/ecookbook/rdb'

    expect(current_path).to eq('/projects/ecookbook/rdb/taskboard')
  end
end
