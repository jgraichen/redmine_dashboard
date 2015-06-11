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

    open '#rdb-menu' do
      click_on 'Create new Dashboard'
    end

    expect(page).to have_content 'New Board (2)'
  end

  scenario 'Switch back to old dashboard' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    open '#rdb-menu' do
      click_on 'Create new Dashboard'
    end

    expect(board_title).to have_text 'New Board (2)'

    open '#rdb-menu' do
      click_on 'New Board'
    end

    expect(board_title).to have_text 'New Board'
  end
end
