ENV['RAILS_ENV'] ||= 'test'

env = File.expand_path('../../../config/environment.rb', __FILE__)
if File.exist? env
  require env
else
  require 'bundler'
  ::Bundler.with_unbundled_env do
    Kernel.exec *[
      File.expand_path('../../../redmine', __FILE__),
      %w(exec bundle exec rspec),
      ARGV
    ].flatten
  end
end

if defined?(Test::Unit::AutoRunner)
  Test::Unit::AutoRunner.need_auto_run = false
end

require 'rspec'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'database_cleaner'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.expand_path('../support/**/*.rb', __FILE__)].each {|f| require f }

RSpec.configure do |config|
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
  config.global_fixtures = [
    :projects, :trackers, :trackers, :users, :versions, :issue_categories,
    :issue_relations, :enumerations, :issues, :member_roles, :members,
    :roles, :workflows]

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  if ENV['CI'] || ENV['HEADLESS']
    require 'headless'
    headless = Headless.new
    headless.start

    at_exit { headless.destroy }
  end

  # Include request spec helpers
  config.include Unreliable
  config.include RdbRequestHelpers
  config.include Capybara::DSL
  config.include Capybara::RSpecMatchers
  config.include Rails.application.routes.url_helpers

  Capybara.default_host = 'http://example.org'
  Capybara.default_max_wait_time = 5

  # Use alternative chromedriver binary if not installed in PATH
  # e.g. with the Ubuntu chromium-chromedriver package
  %w(
    /usr/lib/chromium/chromedriver
    /usr/lib/chromium-browser/chromedriver
  ).find do |file|
    if File.executable?(file)
      Selenium::WebDriver::Chrome.driver_path = file
    end
  end

  case ENV.fetch('BROWSER', 'chromium')
    when /^f(irefox|f)$/i
      Capybara.javascript_driver = :selenium
    when /^chrom(e|ium)$/i
      Capybara.javascript_driver = :selenium_chrome
    else
      throw RuntimerError.new "Unknown browser engine: #{ENV['BROWSER']}"
  end

  if ENV['CI'] || ENV['HEADLESS']
    Capybara.javascript_driver = :'#{Capybara.javascript_driver}_headless'
  end

  config.before(:each) do
    if page.driver.respond_to?(:resize)
      page.driver.resize 1280, 1024
    else
      page.driver.browser.manage.window.resize_to 1280, 1024
    end

    Capybara.reset_sessions!
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
