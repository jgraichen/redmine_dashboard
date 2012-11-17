# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match 'projects/:id/rdb', :controller => 'rdb_dashboard', :action => 'index', :as => :rdb_dashboard
match 'projects/:id/dashboard', :controller => 'rdb_dashboard', :action => 'index'
match 'projects/:id/rdb/configure', :controller => 'rdb_dashboard', :action => 'configure', :as => :rdb_configure
match 'projects/:id/rdb/taskboard', :controller => 'rdb_taskboard', :action => 'index', :as => :rdb_taskboard
match 'projects/:id/rdb/planningboard', :controller => 'rdb_planningboard', :action => 'index', :as => :rdb_planningboard
