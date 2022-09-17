# frozen_string_literal: true

# Download chromedriver: Github Actions CI environments already have
# everything preinstalled
require 'webdrivers' unless ENV['CI'].present?

require 'capybara/rails'
require 'capybara/rspec'

Capybara.default_host = 'http://example.org'
Capybara.default_max_wait_time = 15

case (browser = ENV.fetch('BROWSER', 'chromium'))
  when /^f(irefox|f)$/i
    Capybara.default_driver = :selenium
  when /^chrom(e|ium)$/i
    Capybara.default_driver = :selenium_chrome
  else
    raise "unknown browser engine: #{browser}"
end

if ENV['CI'] || ENV['HEADLESS']
  Capybara.default_driver = :"#{Capybara.default_driver}_headless"
end

RSpec.configure do |config|
  config.before(:each, type: :feature) do
    page.driver.browser.manage.window.resize_to(1280, 1024)
  end
end
