ENV["RAILS_ENV"] ||= 'test'

env = File.expand_path('../../config/environment.rb', __FILE__)
if File.exist? env
  require env
else
  require 'bundler'
  ::Bundler.with_clean_env do
    Kernel.exec "./redmine exec bundle exec rspec #{ARGV.map(&:inspect).join(' ')}"
  end
end

if defined?(Test::Unit::AutoRunner)
  Test::Unit::AutoRunner.need_auto_run = false
end

require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path("../support/**/*.rb", __FILE__)].each {|f| require f}

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Use Redmine fixtures
  config.fixture_path = "#{::Rails.root}/test/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Include request spec helpers
  config.include RdbRequestHelpers, :type => :feature

  DatabaseCleaner.strategy = :truncation

  Capybara.default_host = 'http://example.org'
  Capybara.javascript_driver = :poltergeist
  Capybara.default_wait_time = 15
end
