# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'

Capybara.default_host = 'http://example.org'
Capybara.javascript_driver = :selenium_chrome
Capybara.default_max_wait_time = 15

if %w[0 no off false].include?(ENV['HEADLESS'])
  Capybara.javascript_driver = :selenium_chrome
else
  Capybara.javascript_driver = :selenium_chrome_headless
end

RSpec.configure do |config|
  config.before(:each, js: true) do
    page.driver.browser.manage.window.resize_to(1280, 1024)

    # https://github.com/teamcapybara/capybara/issues/2800#issuecomment-2728801284
    unless page.driver.invalid_element_errors.include?(Selenium::WebDriver::Error::UnknownError)
      page.driver.invalid_element_errors << Selenium::WebDriver::Error::UnknownError
    end
  end
end
