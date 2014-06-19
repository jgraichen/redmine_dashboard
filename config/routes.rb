# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'projects/:id/dashboards' => 'rdb_project_boards#index'
get 'my/dashboards'           => 'rdb_user_boards#index'

get '/dashboards/:board_id'           => 'rdb#show',  as: :rdb
get '/dashboards/:board_id/configure' => 'rdb#show',  as: :rdb_configure
get '/dashboards/new'                 => 'rdb#new',   as: :rdb_new

if Rails.env.development?
  require 'rdb/assets'
  Rdb::Assets.env = Sprockets::Environment.new Rails.root
  Rdb::Assets.setup(Rdb::Assets.env)

  mount Rdb::Assets.env, at: '/rdb/assets'
end
