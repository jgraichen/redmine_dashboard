require 'spec_helper'

describe 'Dashboard', js: true, sauce: true do
  let(:project) { Project.find 'ecookbook' }

  before do
    set_permissions
    enable_plugin project
    login_as 'dlopper', 'foo'
  end

  it 'should redirect to new dashboard' do
    visit '/projects/ecookbook'

    within '#main-menu' do
      click_on 'Dashboards'
    end

    expect(current_path).to eq '/dashboards/1'
  end

  it 'should have default dashboard name' do
    visit '/dashboards/1'

    expect(page).to have_content 'New Dashboard'
  end

  it 'should create new dashboard' do
    visit '/dashboards/1'

    within '#rdb-board-menu' do
      click_on 'New Dashboard'
    end

    fill_in 'Dashboard Name', with: 'My New Board'
    choose 'Taskboard'

    expect(current_path).to eq '/dashboards/2'
    expect(page).to have_content 'My New Board'
  end
end
