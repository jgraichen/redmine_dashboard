# frozen_string_literal: true

# Check and setup test environment
require_relative '../reexec'

require 'rspec'
require 'rspec/rails'
require 'database_cleaner/active_record'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path('support/**/*.rb', __dir__)].each {|f| require f }

RSpec.configure do |config|
  config.order = 'random'
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = false

  # Use Redmine fixtures
  config.fixture_path = "#{Rails.root}/test/fixtures"

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
