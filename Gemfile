source 'https://rubygems.org'
# Gems required by redmine_dashboard

send :ruby, RUBY_VERSION if ENV['CI']

gem 'haml'
gem 'rake'

group :development do
  gem 'transifex-ruby-fork-jg', require: false
  gem 'inifile', require: false
end

group :test do
  gem 'rspec', '~> 3.6'
  gem 'rspec-rails'
  gem 'database_cleaner'
end
