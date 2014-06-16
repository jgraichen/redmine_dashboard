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

    expect(current_path).to eq '/dashboards/1'
  end

  scenario 'Create new board' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    find('.rdb-js-board-menu').click
    click_on 'Create new Board'

    expect(current_path).to eq '/dashboards/2'
    expect(page).to have_content 'New Board (2)'
  end
end
