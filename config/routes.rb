# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

match 'projects/:id/rdb'               => 'rdb_board#index', :as => :rdb_board
match 'projects/:id/rdb/:board'        => 'rdb_board#show',  :as => :rdb_board

