require 'spec_helper'

feature 'Rename dashboard', js: true, sauce: true do
  let(:project) { Project.find 'ecookbook' }

  before do
    set_permissions
    enable_plugin project
    login_as 'dlopper', 'foo'
    visit '/projects/ecookbook'
  end

  scenario 'Rename dashboard' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    find('#rdb-menu').click
    click_on 'Configure Dashboard'

    find(:fillable_field, 'Dashboard name').fill 'New dashboard name'

    find('#rdb-return').click

    expect(page).to have_content 'New dashboard name'
  end

  scenario 'Rename dashboard failed if empty' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    find('#rdb-menu').click
    click_on 'Configure Dashboard'

    find(:fillable_field, 'Dashboard name').fill ''
    find('body').click

    expect(page).to have_content "can't be blank"
  end

  scenario 'Rename dashboard failed if already taken' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    find('#rdb-menu').click
    click_on 'Create new Dashboard'

    find('#rdb-menu').click
    click_on 'Configure Dashboard'

    find(:fillable_field, 'Dashboard name').fill 'New Board'
    find('body').click

    expect(page).to have_content "already been taken"
  end
end
