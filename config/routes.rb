# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'projects/:id/rdb' => 'rdb_project#index'
get 'my/rdb' => 'rdb_user#index'

get '/rdb/dashboards' => 'rdb#index', as: :rdb_index
get '/rdb/dashboards/:id/new' => 'rdb#create', as: :rdb_new
get '/rdb/dashboards/:id(/*path)' => 'rdb#show', as: :rdb

defaults format: :json do
  scope '/rdb/api', module: :rdb do
    resources :boards, only: [:index, :show, :update], as: :rdb_boards do
      resources :issues, only: [:index, :show, :update]
    end
  end
end
