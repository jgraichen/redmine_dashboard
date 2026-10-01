# frozen_string_literal: true

require 'spec_helper'

describe 'Admin: Issue Priority Color', js: true do
  fixtures %i[
    enumerations
    users
  ]

  let(:priority) { IssuePriority.find_by!(name: 'Normal') }

  before do
    login_as_admin
  end

  it 'allows selecting and saving a color' do
    visit "/enumerations/#{priority.id}/edit"

    within_fieldset('Dashboard: Color') do
      expect(page).to have_field('red-100')
      expect(page).to have_field('blue-300')
      expect(page).to have_field('green-500')
      expect(page).to have_field('yellow-700')

      choose 'gray-500'
    end

    click_on 'Save'
    click_on 'Normal'

    expect(page).to have_field('enumeration[dashboard_color]', with: 'gray-500', checked: true)
    expect(priority.reload.dashboard_color).to eq('gray-500')
  end

  context 'for non-priority enumerations' do
    let(:activity) { TimeEntryActivity.find_by(name: 'Design') }

    it 'does not show the color picker' do
      visit "/enumerations/#{activity.id}/edit"
      expect(page).not_to have_selector('fieldset')
    end
  end
end
