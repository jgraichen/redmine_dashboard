source 'https://rubygems.org'
# Gems required by redmine_dashboard

ruby RUBY_VERSION if ENV['TRAVIS_CI']

gem 'haml'

group :development do
  gem 'transifex-ruby-fork-jg', require: false
  gem 'inifile', require: false
end

group :test do
  gem 'rspec', '~> 2.0'
  gem 'rspec-rails'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'fuubar'
end
