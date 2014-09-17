source 'https://rubygems.org'
# Gems required by redmine_dashboard

gem 'haml'

group :development do
  gem 'guard-rspec'
  gem 'transifex-ruby-fork-jg', github: 'jgraichen/transifex-ruby', require: false
  gem 'inifile', require: false
end

group :test do
  gem 'rspec', '~> 2.0'
  gem 'rspec-rails'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'fuubar'

  # for redmine on travis CI
  gem 'test-unit'
end
