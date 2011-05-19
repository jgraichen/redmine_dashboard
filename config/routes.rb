
ActionController::Routing::Routes.draw do |map|
  map.connect 'projects/:id/dashboard', :controller => 'dashboard', :action => 'index'
end