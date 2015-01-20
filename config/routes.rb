# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match 'projects/:id/rdb/taskboard'        => 'rdb_taskboard#index',  :as => :rdb_taskboard,        via: [:get, :post]
match 'projects/:id/rdb/taskboard/move'   => 'rdb_taskboard#move',   :as => :rdb_taskboard_move,   via: [:get, :post]
match 'projects/:id/rdb/taskboard/update' => 'rdb_taskboard#update', :as => :rdb_taskboard_update, via: [:get, :post]
match 'projects/:id/rdb/taskboard/filter' => 'rdb_taskboard#filter', :as => :rdb_taskboard_filter, via: [:get, :post]


match 'projects/:id/rdb(/:board)'  => 'rdb_dashboard#index', :as => :rdb, via: [:get, :post]
match 'projects/:id/dashboard'     => 'rdb_dashboard#index', via: [:get, :post]
