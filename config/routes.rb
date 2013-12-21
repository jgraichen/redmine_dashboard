# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'projects/:id/dashboards' => 'rdb_project_boards#index'
get 'my/dashboards'           => 'rdb_user_boards#index'

get  '/dashboards/:board_id'           => 'rdb#show',      :as => :rdb
get  '/dashboards/:board_id/configure' => 'rdb#configure', :as => :configure_rdb
post '/dashboards/:board_id'           => 'rdb#create'
put  '/dashboards/:board_id'           => 'rdb#update'
