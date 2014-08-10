source 'https://rubygems.org'
# Gems required by redmine_dashboard

gem 'slim'

group :development do
  gem 'rspec', '~> 3.0'

  gem 'sass'
  gem 'bourbon'

  gem 'pry'
  gem 'pry-nav'

  gem 'transifex-ruby', github: 'jgraichen/transifex-ruby', require: false
  gem 'inifile', require: false
end

group :test do
  gem 'rspec-rails', require: false
  gem 'database_cleaner', require: false
  gem 'fuubar', require: false
  gem 'headless', require: false

  # for redmine on travis CI
  gem 'test-unit'
end
