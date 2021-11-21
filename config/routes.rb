# frozen_string_literal: true

get 'projects/:id/rdb', to: 'rdb_boards#index', as: :rdb_boards
get 'projects/:id/rdb(/:board_id)', to: 'rdb_boards#show', as: :rdb_board
post 'projects/:id/rdb(/:board_id)', to: 'rdb_boards#update'
