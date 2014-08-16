require File.expand_path '../../../spec_helper', __FILE__

feature 'Create dashboard', js: true, sauce: true do
  let(:project) { Project.find 'ecookbook' }

  before do
    set_permissions
    enable_plugin project
    login_as 'dlopper', 'foo'
    visit '/projects/ecookbook'
  end

  scenario 'Create new dashboard' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    find('#rdb-menu').click
    click_on 'Create new Dashboard'

    expect(page).to have_content 'New Board (2)'
  end

  scenario 'Switch back to old dashboard' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    find('#rdb-menu').click
    click_on 'Create new Dashboard'

    expect(page).to have_content 'New Board (2)'

    find('#rdb-menu').click
    click_on 'New Board'

    expect(page).to have_content 'New Board'
    expect(current_url).to =~ /\/dashboards\/1/
  end
end
