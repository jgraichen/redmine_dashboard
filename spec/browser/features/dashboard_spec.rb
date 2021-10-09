# frozen_string_literal: true

require_relative '../spec_helper'

feature 'Dashboard' do
  let(:project) { Project.find 'ecookbook' }

  before do
    set_permissions

    project.enable_module! 'issue_tracking'
    project.enable_module! 'dashboard'
    project.save!

    login_as 'dlopper', 'foo'
    visit '/projects/ecookbook'
  end

  scenario 'Open initial new board from project menu' do
    within '#main-menu' do
      click_on 'Dashboards'
    end

    expect(page).to have_content 'Default eCookbook board'
  end
end
