# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'projects/:id/dashboards' => 'rdb_project_boards#index'
get 'my/dashboards'           => 'rdb_user_boards#index'

get '/dashboards/:board_id/new'     => 'rdb#create',    as: :rdb_new
get '/dashboards/:board_id(/*path)' => 'rdb#show',      as: :rdb
