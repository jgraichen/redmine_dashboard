require 'spec_helper'

describe "Taskboard/Filter/Versions", :js => true, :sauce => true do
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

  context 'menu' do
    let(:menu) { find_menu_container(:versions) }

    it 'should have items for all versions' do
      unset_all_filter
      find_menu_link(:versions).click

      menu.should have_link('2.0')
      menu.should have_link('1.0')
    end
  end

  it 'should allow to filter issues for versions' do
    unset_all_filter
    select_filter :versions, '1.0'

    page.should have_selector(:xpath, '//*[contains(@class, "rdb-property-version")][text()="1.0"]', :count => 2)
    page.should have_no_selector(:xpath, '//*[contains(@class, "rdb-property-version")][text()!="1.0"]')
  end

  it "should default to most recent not closed verion" do
    find_menu_link(:versions).should have_content('1.0')
  end
end
