# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match 'projects/:id/dashboard', :controller => 'dashboard', :action => 'taskboard', :as => :taskboard
match 'projects/:id/dashboard/planning', :controller => 'dashboard', :action => 'planboard', :as => :planboard
