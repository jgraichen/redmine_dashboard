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

group :test do
  gem 'capybara', '~> 3.39.0'
  gem 'rubocop', '~> 1.49.0'
end
