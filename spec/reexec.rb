# frozen_string_literal: true

# If we are running *inside* the Redmine Rails environment, we can just required
# the environment file bootstrap and start the Rails application. Otherwise, we
# have been directly called from the plugin directory und must restart the rspec
# command through the `./redmine` execution wrapper.
env = File.expand_path('config/environment.rb', Dir.pwd)
unless File.exist?(env)
  require 'bundler'
  ::Bundler.with_original_env do
    # Unset BUNDLE_GEMFILE to force using Redmine's Gemfile
    ENV['BUNDLE_GEMFILE'] = nil

    cmd = "./redmine exec bundle exec rspec #{ARGV.map(&:inspect).join(' ')}"
    puts "+ #{cmd}"

    Kernel.exec(cmd)
  end
end

# Load Rails application test environment
ENV['RAILS_ENV'] ||= 'test'
require env
