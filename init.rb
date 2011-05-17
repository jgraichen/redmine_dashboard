require 'redmine'

Redmine::Plugin.register :redmine_dashboard do
  name 'Redmine Dashboard plugin'
  author 'Jan Graichen'
  description 'Add an Issue Dashboard to Redmine'
  version '0.3'
  url 'http://altimos.de/'
  author_url 'mailto:jan.graichen@altimos.de'
  
  project_module :dashboard do
    permission :view_dashboard, { :dashboard => :index }
    permission :edit_dashboard, { :dashboard => :update }
  end
  menu :project_menu, :dashboard, { :controller => 'dashboard', :action => 'index' }
  
end