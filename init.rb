# frozen_string_literal: true

$LOAD_PATH.unshift "#{__dir__}/lib"

# Explicitly register the plugin's hooks and patches again since they
# are lost in development environment when code is reloaded.
#
# The classes are automatically resolved by Zeitwerk, but stored
# references get lost on reloaded. Since Redmine does reload the
# `init.rb` then too, we can just re-register the hooks and patches
# here.
RedmineDashboard::Hooks.register!
RedmineDashboard::Patch.apply!

Redmine::Plugin.register :redmine_dashboard do
  name 'Redmine Dashboard plugin'
  author 'Jan Graichen'
  description 'Add a task board and a planning board to Redmine'
  version '2.16.0'
  url 'https://github.com/jgraichen/redmine_dashboard'
  author_url 'mailto:jgraichen@altimos.de'

  requires_redmine '5.0'

  project_module :dashboard do
    permission :view_dashboards, {
      rdb_dashboard: [:index],
      rdb_taskboard: %i[index filter move update]
    }
    permission :configure_dashboards, {rdb_dashboard: [:configure]}
  end

  menu :project_menu, :dashboard, {controller: 'rdb_dashboard', action: 'index'},
    caption: :menu_label_dashboard, after: :new_issue
end
