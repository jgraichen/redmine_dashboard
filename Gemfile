# frozen_string_literal: true

source 'https://rubygems.org'
# Gems required by redmine_dashboard

send :ruby, RUBY_VERSION if ENV['CI']

# Patch `#gem` to replace an already declared gem instead of flat our
# refusing to do anything. This is important, for example, as our tests
# require a specific version of `capybara`, which is already defined in
# Redmines Gemfile, but without the correct version constraint.
def gem(name, *constraints)
  # Remove existing dependency
  @dependencies.reject! {|d| d.name == name }
  super
end

gem 'rake'
gem 'slim-rails'

group :test do
  gem 'database_cleaner-active_record', '~> 2.0'
  gem 'rspec', '~> 3.10'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara', '~> 3.38.0'
  gem 'rubocop', '~> 1.39.0'
  gem 'slim_lint', '~> 0.22.1'
end
