# frozen_string_literal: true

module Helpers
  def set_permissions
    role = Role.where(name: 'Manager').first
    role.permissions << :view_dashboards
    role.permissions << :configure_dashboards
    role.save!

    role = Role.where(name: 'Developer').first
    role.permissions << :view_dashboards
    role.save!
  end

  def login_as(user, password)
    visit url_for(controller: 'account', action: 'login', only_path: true)
    fill_in 'username', with: user
    fill_in 'password', with: password
    page.find(:xpath, '//input[@name="login"]').click
    @user = User.find_by(login: user)
  end

  def login_as_user
    login_as('jsmith', 'jsmith')
  end

  def login_as_admin
    login_as('admin', 'admin')
  end
end

RSpec.configure do |config|
  config.include Helpers, type: :feature
end
