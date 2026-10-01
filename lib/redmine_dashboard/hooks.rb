# frozen_string_literal: true

module RedmineDashboard
  class Hooks < Redmine::Hook::ViewListener
    def self.register!
      # Avoid registering the hook multiple times in development mode
      # when code is reloaded or loaded the first time, and the previous
      # registration is not lost (usually it is).
      unless Redmine::Hook.listeners.any?(self)
        Redmine::Hook.add_listener(self)
      end
    end

    def view_layouts_base_html_head(_context)
      stylesheet_link_tag 'global.css', plugin: :redmine_dashboard
    end
  end
end
