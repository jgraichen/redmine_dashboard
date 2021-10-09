# frozen_string_literal: true

require 'rspec/core/rake_task'

task default: [:spec]

desc 'Run all specs (alias for spec:all)'
task spec: 'spec:all'

namespace :spec do
  desc 'Run plugin and browser specs'
  task all: %i[plugin browser]

  desc 'Run plugin specs'
  RSpec::Core::RakeTask.new(:plugin) do |t|
    t.pattern    = 'spec/plugin'
    t.ruby_opts  = '-Ispec/plugin'
    t.rspec_opts = "--seed #{ENV['SEED']}" if ENV['SEED']
  end

  desc 'Run browser specs'
  RSpec::Core::RakeTask.new(:browser) do |t|
    t.pattern    = 'spec/browser'
    t.ruby_opts  = '-Ispec/browser'
    t.rspec_opts = "--seed #{ENV['SEED']}" if ENV['SEED']
  end
end
