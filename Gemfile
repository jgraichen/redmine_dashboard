source 'https://rubygems.org'
# Gems required by redmine_dashboard

gem 'slim'

group :development do
  gem 'rake'
  gem 'rspec'

  gem 'sprockets-standalone', :require => false
  gem 'stylus',               :require => false
  gem 'sass',                 :require => false
  gem 'uglifier',             :require => false
  gem 'coffee-script',        :require => false
end

group :test do
  gem 'rspec-rails'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'guard-rspec'
  gem 'capybara', '~> 2.1.0'
  gem 'fuubar'

  # for redmine on travis CI
  gem 'test-unit'
end
