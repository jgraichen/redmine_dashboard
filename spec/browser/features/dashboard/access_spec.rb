require File.expand_path '../../../spec_helper', __FILE__

feature 'Configure dashboard access', js: true, sauce: true do
  let(:project) { Project.find 'ecookbook' }

  before do
    set_permissions
    enable_plugin project
    login_as 'dlopper', 'foo'
    visit '/projects/ecookbook'

    within '#main-menu' do
      click_on 'Dashboards'
    end

    find('#rdb-menu').click
    click_on 'Configure Dashboard'
  end
end
