# frozen_string_literal: true

module Support
  module Permissions
    def set_permissions
      role = Role.where(name: 'Manager').first
      role.permissions << :view_dashboards
      role.permissions << :configure_dashboards
      role.save!

      role = Role.where(name: 'Developer').first
      role.permissions << :view_dashboards
      role.save!
    end

    RSpec.configuration.include self, type: :controller
  end
end
