# encoding: UTF-8
require File.expand_path("../../spec_helper", __FILE__)

describe "Rdb", :js => true, :sauce => true do
  fixtures :projects, :projects_trackers, :users, :members,
    :member_roles, :issues, :issue_categories,
    :issue_statuses, :enumerations, :roles, :time_entries,
    :versions, :workflows

  let(:project) { Project.find 'ecookbook' }

  before do
    set_permissions
    project.enable_module! 'dashboard'
    login_as 'dlopper', 'foo'
  end

  it "should redirect to taskboard" do
    visit '/projects/ecookbook/rdb'

    current_path.should eq('/projects/ecookbook/rdb/taskboard')
  end
end
