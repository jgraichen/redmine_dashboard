# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'

Capybara.default_host = 'http://example.org'
Capybara.default_max_wait_time = 15

case ENV.fetch('BROWSER', 'chromium')
  when /^f(irefox|f)$/i
    Capybara.default_driver = :selenium
  when /^chrom(e|ium)$/i
    Capybara.default_driver = :selenium_chrome
  else
    raise "unknown browser engine: #{ENV['BROWSER']}"
end

if ENV['CI'] || ENV['HEADLESS']
  Capybara.default_driver = :"#{Capybara.default_driver}_headless"
end

RSpec.configure do |config|
  config.before(:each, type: :feature) do
    page.driver.browser.manage.window.resize_to(1280, 1024)
  end
end
