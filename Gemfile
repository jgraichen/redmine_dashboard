# frozen_string_literal: true

source 'https://rubygems.org'
# Gems required by redmine_dashboard

send :ruby, RUBY_VERSION if ENV['CI']

gem 'rake'
gem 'slim-rails'

group :test do
  gem 'database_cleaner-active_record', '~> 2.0'

  gem 'rspec', '~> 3.10'
  gem 'rspec-rails'

  # Redmine already defines capybara and puma, which required to run
  # browser tests.
end

# If rubocop is already defined, the Gemfile is loaded through Redmine's
# own Gemfile as a plugin. In that case our local development gems are
# not needed (and actually conflicting), therefore we skip them.
if @dependencies.none? {|d| d.name == 'rubocop' }
  group :development do
    gem 'rubocop', '~> 1.74.0'
    gem 'rubocop-performance', '~> 1.24.0'
    gem 'rubocop-rails', '~> 2.30.0'
    gem 'slim_lint', '~> 0.32.0'
  end
end
