require File.expand_path '../../../spec_helper', __FILE__

feature 'Dashboard Permissions', js: true, sauce: true do
  let(:project) { Project.find 'ecookbook' }

  before do
    set_permissions
    enable_plugin project
    login_as 'dlopper', 'foo'
    visit '/projects/ecookbook'
  end

  scenario 'List permissions' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    within '.contextual' do
      click_on 'Configure'
    end

    expect(page).to have_content 'Access control'

    within :xpath, "//td[contains(., 'Dave Lopper')]/.." do
      expect(page.find('.rdb-active')).to have_content 'ADMIN'
    end
  end

  scenario 'Add permissions' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    within '.contextual' do
      click_on 'Configure'
    end

    find(:fillable_field, 'Search user or group', match: :prefer_exact)
      .fill 'Lo'

    click_on 'Dave2 Lopper2'

    rui_select 'Read' do
      click_on 'Edit'
    end

    click_on 'Add'

    within :xpath, "//td[contains(., 'Dave2 Lopper2')]/.." do
      expect(page.find('.rdb-active')).to have_content 'EDIT'
    end
  end
end
