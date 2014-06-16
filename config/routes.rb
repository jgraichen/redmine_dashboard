# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'projects/:id/dashboards' => 'rdb_project_boards#index'
get 'my/dashboards'           => 'rdb_user_boards#index'

get '/dashboards/:board_id'           => 'rdb#show',  as: :rdb
get '/dashboards/:board_id/configure' => 'rdb#show',  as: :rdb_configure
get '/dashboards/new'                 => 'rdb#new',   as: :rdb_new

if Rails.env.development?
  require 'sprockets'

  environment = Sprockets::Environment.new Dir.pwd

  %w(app/assets/images
     app/assets/stylesheets
     app/assets/javascripts
     vendor/assets/javascripts
     vendor/assets/stylesheets).each do |source|
    environment.append_path File.join('plugins', 'redmine_dashboard', source)
  end

  mount environment, at: '/rdb/assets'
end
