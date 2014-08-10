require 'spec_helper'

feature 'Boards', js: true, sauce: true do
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

  scenario 'Create new board' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    find('#rdb-menu').click
    click_on 'Create new Dashboard'

    expect(page).to have_content 'New Board (2)'
  end

  scenario 'Toggle fullscreen' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    expect(page).to have_css '#main-menu', visible: true

    find('#rdb-fullscreen').click

    expect(page).to have_css '#main-menu', visible: false
  end

  scenario 'Rename board' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    find('#rdb-menu').click
    click_on 'Configure Dashboard'

    find(:fillable_field, 'Dashboard name').fill 'New dashboard name'

    find('#rdb-return').click

    expect(page).to have_content 'New dashboard name'
  end
end
