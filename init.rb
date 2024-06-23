# frozen_string_literal: true

require 'redmine'

Rails.configuration.to_prepare do
  require 'rdb/rails/i18n'
end

Redmine::Plugin.register :redmine_dashboard do
  name 'Redmine Dashboard plugin'
  author 'Jan Graichen'
  description 'Add a task board and a planning board to Redmine'
  version '3.0-dev'
  url 'https://github.com/jgraichen/redmine_dashboard'
  author_url 'mailto:jgraichen@altimos.de'

  requires_redmine version_or_higher: '5.1'

  project_module :dashboard do
    permission :view_dashboards,
      rdb_boards: %i[index show update]
  end

  menu :project_menu, :dashboards,
    {controller: 'rdb_boards', action: 'index'},
    caption: :'rdb.menu.project.dashboards',
    after: :new_issue
end
