require File.expand_path '../../spec_helper', __FILE__

feature 'Dashboard', js: true, sauce: true do
  let(:project) { Project.find 'ecookbook' }

  before do
    set_permissions
    enable_plugin project
    login_as 'dlopper', 'foo'
    visit '/projects/ecookbook'
  end

  scenario 'Open initial new board from project menu' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    expect(page).to have_content 'New Board'
  end

  scenario 'Toggle fullscreen' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    expect(page).to have_css '#main-menu', visible: true

    within '.contextual' do
      click_on 'Fullscreen'
    end

    expect(page).to have_css '#main-menu', visible: false
  end
end
