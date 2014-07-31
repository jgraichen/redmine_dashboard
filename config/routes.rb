# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'projects/:id/rdb' => 'rdb_project_dashboards#index'
get 'my/rdb' => 'rdb_user_dashboards#index'

get '/rdb/dashboards/:id/new' => 'rdb_dashboards#create', as: :rdb_new
get '/rdb/dashboards/:id(/*path)' => 'rdb_dashboards#show', as: :rdb

defaults format: :json do
  scope '/rdb/api' do
    resources :dashboards, only: [:show, :update], as: :rdb_dashboards do
      resources :issues, only: [:index, :show, :update]
    end
  end
end
