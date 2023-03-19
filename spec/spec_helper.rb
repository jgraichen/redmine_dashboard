# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

env = File.expand_path('config/environment.rb', Dir.pwd)

if File.exist? env
  require env
else
  require 'bundler'
  Bundler.with_original_env do
    # Unset BUNDLE_GEMFILE to force using Redmines Gemfile
    ENV['BUNDLE_GEMFILE'] = nil

    cmd = "./redmine exec bundle exec rspec #{ARGV.map(&:inspect).join(' ')}"
    puts "+ #{cmd}"

    Kernel.exec(cmd)
  end
end

if defined?(Test::Unit::AutoRunner)
  Test::Unit::AutoRunner.need_auto_run = false
end

# Eager load Rails application in CI. This will catch any
# eager-load-only problem that would otherwise only appear in
# production. Tests in CI also do not need any reload, so eager loader
# is feasable and useful.
Rails.application.eager_load! if ENV['CI'].present?

# Download chromedriver; Github Actions already has everything preinstalled
require 'webdrivers' unless ENV['CI'].present?

require 'rspec/rails'
require 'database_cleaner/active_record'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path('support/**/*.rb', __dir__)].sort.each {|f| require f }

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.order = 'random'

  # Use Redmine fixtures
  config.fixture_path = "#{Rails.root}/test/fixtures"

  # Include request spec helpers
  config.include RdbRequestHelpers

  config.around(:each) do |example|
    DatabaseCleaner.clean_with(:truncation)
    example.run
  end
end
