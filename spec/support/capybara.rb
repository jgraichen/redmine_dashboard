# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'

Capybara.default_host = 'http://example.org'
Capybara.javascript_driver = :selenium_chrome
Capybara.default_max_wait_time = 15
Capybara.server = :webrick

# The test setup expects a linux system with `chromium` and
# `chromium-chromedriver` installed. `chromedriver` must be available in PATH,
# and is configured here to default to using `/usr/bin/chromium`. As both are
# provided by the distribution their version should always match, even if
# `google-chrome` is installed too.
#
if ENV['CHROME_PATH']
  puts "Using chrome path from environment: #{ENV['CHROME_PATH']}"
  Selenium::WebDriver::Chrome.path = ENV['CHROME_PATH']
else
  %w[
    /usr/bin/chromium
    /usr/bin/chromium-browser
    /usr/bin/google-chrome
  ].each do |path|
    next unless File.executable?(path)

    Selenium::WebDriver::Chrome.path = path
    puts "Using detected chrome path: #{path}"
    break
  end
end

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
