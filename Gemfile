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

  # Webrick is no longer bundled with Ruby 3.0+ but required by
  # capybara. If Redmine does not already include it in it's own
  # Gemfile, we need to add it here.
  if @dependencies.none? {|d| d.name == 'webrick' }
    gem 'webrick'
  end
end

# If rubocop is already defined, the Gemfile is loaded through Redmins own
# Gemfile as a plugin Gemfile. In that case our local development gems are not
# needed (and actually conflicting), therefore we skip them.
if @dependencies.none? {|d| d.name == 'rubocop' }
  group :development, :test do
    gem 'rubocop', '~> 1.51.0'
    gem 'slim_lint', '~> 0.24.0'
  end
end
