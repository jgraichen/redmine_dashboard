require 'redmine'
require 'haml'

Rails.configuration.to_prepare do
  require 'rdb/rails/i18n'
end

Redmine::Plugin.register :redmine_dashboard do
  name 'Redmine Dashboard plugin'
  author 'Jan Graichen'
  description 'Add a task board and a planning board to Redmine'
  version '2.7.0'
  url 'https://github.com/jgraichen/redmine_dashboard'
  author_url 'mailto:jg@altimos.de'

  requires_redmine :version_or_higher => '2.1'

  project_module :dashboard do
    permission :view_dashboards, {
      :rdb_dashboard => [:index ],
      :rdb_taskboard => [:index, :filter, :move, :update ] }
    permission :configure_dashboards, { :rdb_dashboard => [:configure] }
  end
  menu :project_menu, :dashboard, { :controller => 'rdb_dashboard', :action => 'index' },
    :caption => :menu_label_dashboard, :after => :new_issue

end
