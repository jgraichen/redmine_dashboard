# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'

Capybara.default_host = 'http://example.org'
Capybara.javascript_driver = :selenium_chrome
Capybara.default_max_wait_time = 15
Capybara.server = :webrick

if %w[0 no off false].include?(ENV['HEADLESS'])
  Capybara.javascript_driver = :selenium_chrome
else
  Capybara.javascript_driver = :selenium_chrome_headless
end

RSpec.configure do |config|
  config.before(:each, js: true) do
    page.driver.browser.manage.window.resize_to(1280, 1024)
  end
end
