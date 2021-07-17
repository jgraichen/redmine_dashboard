# frozen_string_literal: true

source 'https://rubygems.org'
# Gems required by redmine_dashboard

send :ruby, RUBY_VERSION if ENV['CI']

# Skip if gem is already defined. This happens when the Gemfile is evalauated
# within Redmines Gemfile. Development tools such as rubocop are only needed in
# our specific version when installed outside of Redmine.
def gem?(name, *args)
  return if @dependencies.any? {|d| d.name == name }

  gem(name, *args)
end

gem 'haml'
gem 'rake'

group :test do
  gem 'database_cleaner-active_record', '~> 2.0'
  gem 'rspec', '~> 3.10'
  gem 'rspec-rails'
end

group :development, :test do
  gem? 'rubocop', '~> 1.18.0'
end
