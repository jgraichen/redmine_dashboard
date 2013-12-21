# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'projects/:project_id/dashboards' => 'rdb_project_boards#index'
get 'my/dashboards'           => 'rdb_user_boards#index'

get  '/dashboards/:id'           => 'rdb#show',      :as => :rdb
get  '/dashboards/:id/configure' => 'rdb#configure', :as => :configure_rdb
post '/dashboards/:id'           => 'rdb#create'
put  '/dashboards/:id'           => 'rdb#update'
