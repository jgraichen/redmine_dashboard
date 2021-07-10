# frozen_string_literal: true

# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match 'projects/:id/rdb/taskboard'        => 'rdb_taskboard#index',  :as => :rdb_taskboard,        via: %i[get post]
match 'projects/:id/rdb/taskboard/move'   => 'rdb_taskboard#move',   :as => :rdb_taskboard_move,   via: %i[get post]
match 'projects/:id/rdb/taskboard/update' => 'rdb_taskboard#update', :as => :rdb_taskboard_update, via: %i[get post]
match 'projects/:id/rdb/taskboard/filter' => 'rdb_taskboard#filter', :as => :rdb_taskboard_filter, via: %i[get post]

match 'projects/:id/rdb(/:board)'  => 'rdb_dashboard#index', :as => :rdb, via: %i[get post]
match 'projects/:id/dashboard'     => 'rdb_dashboard#index', via: %i[get post]
