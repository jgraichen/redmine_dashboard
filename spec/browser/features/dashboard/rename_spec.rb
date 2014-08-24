require File.expand_path '../../../spec_helper', __FILE__

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

    within '.contextual' do
      click_on 'Configure'
    end

    find(:fillable_field, 'Name').fill 'New dashboard name'

    within '.contextual' do
      click_on 'Back'
    end

    expect(page).to have_content 'New dashboard name'
  end

  scenario 'Rename dashboard failed if empty' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    within '.contextual' do
      click_on 'Configure'
    end

    find(:fillable_field, 'Name').fill ''
    find('body').click

    expect(page).to have_content "can't be blank"
  end

  scenario 'Rename dashboard failed if already taken' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    find('#rdb-menu').click
    click_on 'Create new Dashboard'

    within '.contextual' do
      click_on 'Configure'
    end

    find(:fillable_field, 'Name').fill 'New Board'
    find('body').click

    expect(page).to have_content 'already been taken'
  end
end
