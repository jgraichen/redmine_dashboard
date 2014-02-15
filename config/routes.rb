# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get 'projects/:id/dashboards' => 'rdb_project_boards#index'
get 'my/dashboards'           => 'rdb_user_boards#index'

get  '/dashboards/:board_id'           => 'rdb#show',      :as => :rdb
get  '/dashboards/:board_id/configure' => 'rdb#configure', :as => :configure_rdb
post '/dashboards/:board_id'           => 'rdb#create'
put  '/dashboards/:board_id'           => 'rdb#update'

if Rails.env.development?
  require 'sprockets'

  environment = Sprockets::Environment.new Dir.pwd

  require 'stylus/sprockets'
  Stylus.setup environment

  %w(app/assets/images app/assets/stylesheets app/assets/javascripts vendor/assets/javascripts).each do |source|
    environment.append_path File.join('plugins', 'redmine_dashboard', source)
  end

  mount environment, :at => '/rdb/assets'
end
