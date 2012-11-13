# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match 'projects/:id/dashboard', :controller => 'taskboard', :action => 'index', :as => :taskboard
match 'projects/:id/dashboard/plan', :controller => 'planboard', :action => 'index', :as => :planboard
