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

  config.global_fixtures = %i[
    enumerations
    issue_categories
    issue_relations
    issues
    member_roles
    members
    projects
    roles
    trackers
    users
    versions
    workflows
  ]

  config.around(:each) do |example|
    DatabaseCleaner.clean_with(:truncation)
    example.run
  end
end
