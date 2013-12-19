# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'projects/:id/dashboards' => 'rdb_project_boards#index'
get 'my/dashboards'           => 'rdb_user_boards#index'

get  '/dashboards/:id' => 'rdb_boards#show', :as => :rdb_board
post '/dashboards/:id' => 'rdb_boards#create'
put  '/dashboards/:id' => 'rdb_boards#update'
