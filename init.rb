# frozen_string_literal: true

require 'redmine'

Rails.configuration.to_prepare do
  require 'rdb/rails/RdbI18nPatch'
end

Redmine::Plugin.register :redmine_dashboard do
  name 'Redmine Dashboard plugin'
  author 'Jan Graichen'
  description 'Add a task board and a planning board to Redmine'
  version '2.12.0'
  url 'https://github.com/jgraichen/redmine_dashboard'
  author_url 'mailto:jgraichen@altimos.de'

  requires_redmine version_or_higher: '4.0'

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
