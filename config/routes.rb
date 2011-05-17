
ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:id/dashboard', :controller => 'dashboard', :action => 'index'
  map.connect 'projects/:id/dashboard/update_issue', :controller => 'dashboard', :action => 'update_issue'
end