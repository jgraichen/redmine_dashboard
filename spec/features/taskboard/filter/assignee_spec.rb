require 'spec_helper'

describe "Taskboard/Filter/Assignee", :js => true do
  fixtures :projects, :projects_trackers, :users, :members,
    :member_roles, :issues, :issue_categories,
    :issue_statuses, :enumerations, :roles, :time_entries,
    :versions, :workflows

  let(:project) { Project.find 'ecookbook' }

  before do
    set_permissions
    project.enable_module! :dashboard
    login_as_admin

    visit '/projects/ecookbook'
    click_on 'Dashboard'
  end

  it 'should show all assignees in menu' do
    page.should have_selector(:xpath, '//*[contains(@class, "rdb-menu-assignee")]//*[contains(@class, "rdb-list")][2]//a', :count => 2)
  end

  it 'should allow to filter issues for assignee' do
    rdb_menu_item(:versions, 'All Versions').click
    rdb_menu_item(:assignee, 'Dave Lopper').click

    page.should have_selector(:xpath, '//*[contains(@class, "rdb-property-assignee")][text()="Dave Lopper"]')
    page.should have_no_selector(:xpath, '//*[contains(@class, "rdb-property-assignee")][text()!="Dave Lopper"]')
  end
end
