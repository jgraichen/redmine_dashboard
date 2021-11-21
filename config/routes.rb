# frozen_string_literal: true

scope '/rdb', module: :rdb do
  get 'avatar/:id', to: 'avatar#show', as: :rdb_avatar, format: :svg
end

get 'projects/:id/rdb', to: 'rdb_dashboards#index', as: :rdb_dashboards
get 'projects/:id/rdb(/:board_id)', to: 'rdb_dashboards#show', as: :rdb_dashboard
post 'projects/:id/rdb(/:board_id)', to: 'rdb_dashboards#update'
