require 'redmine'

Redmine::Plugin.register :redmine_dashboard do
  name 'Redmine Dashboard plugin'
  author 'Jan Graichen'
  description 'Add a task dashboard to Redmine'
  version '2.0.dev'
  url 'https://github.com/jgraichen/redmine_dashboard'
  author_url 'mailto:jg@altimos.de'

  project_module :dashboard do
    permission :view_taskboard, { :dashboard => [:taskboard] }
    permission :view_planboard, { :dashboard => [:planboard] }
  end
  menu :project_menu, :dashboard, { :controller => 'dashboard', :action => 'taskboard' }

end
