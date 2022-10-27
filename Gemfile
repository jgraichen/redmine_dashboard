# frozen_string_literal: true

source 'https://rubygems.org'
# Gems required by redmine_dashboard

send :ruby, RUBY_VERSION if ENV['CI']

# Patch `#gem` to replace an already declared gem instead of flat our
# refusing to do anything. This is important, for example, as our tests
# require a specific version of `capybara` or `puma`, which is already
# defined in Redmines Gemfile, but without any version constraint.
def gem(name, *constraints)
  # Remove existing dependency
  @dependencies.reject! {|d| d.name == name }
  super
end

gem 'rake'

group :test do
  gem 'database_cleaner-active_record', '~> 2.0'
  gem 'rspec', '~> 3.10'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara', '~> 3.37.1'
  gem 'puma', '< 6' # capybara < 3.38 (not yet released) breaks with Puma 6
  gem 'rubocop', '~> 1.37.0'
end
