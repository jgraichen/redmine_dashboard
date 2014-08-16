require 'redmine'

# require 'rdb/rails/i18n'
require 'rdb/rails/patch'

Rails.configuration.to_prepare do
  Dir.glob File.expand_path('../lib/rdb/patches/**/*.rb', __FILE__) do |patch|
    require_dependency patch
  end

  ActiveSupport::Dependencies
    .autoload_paths << File.expand_path('../lib', __FILE__)

  Rails.configuration.i18n.load_path += Dir[File.expand_path('../app/locales/**/*.{rb,yml}', __FILE__)]
end

Redmine::Plugin.register :redmine_dashboard do
  name 'Redmine Dashboard plugin'
  author 'Jan Graichen'
  description 'Add a task board and a planning board to Redmine'
  version '3.0.dev1'
  url 'https://github.com/jgraichen/redmine_dashboard'
  author_url 'mailto:jg@altimos.de'

  requires_redmine version_or_higher: '2.1'

  project_module :dashboard do
    permission :enable_dashboards,
      rdb_user: [:index],
      rdb_project: [:index]
  end

  menu :project_menu, :rdb_project_dashboards,
    {controller: 'rdb_project', action: 'index'},
    caption: :'rdb.menu.dashboards', after: :new_issue
  menu :top_menu, :rdb_dashboards,
    {controller: 'rdb', action: 'index'},
    caption: :'rdb.menu.dashboards', after: :projects

end
