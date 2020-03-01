require 'yaml'
require 'fileutils'
require 'rubygems'
require 'bundler'
require 'logger'

require 'rspec/core/rake_task'


task default: [:spec]

desc 'Run all specs (alias for spec:all)'
task spec: 'spec:all'

namespace :spec do
  desc 'Run plugin and browser specs'
  task all: [:plugin, :browser]

  desc 'Run plugin specs (Testing within redmine application)'
  RSpec::Core::RakeTask.new(:plugin) do |t|
    t.pattern    = ENV['SPEC'] || "spec/plugin"
    t.ruby_opts  = "-Ispec/plugin"
    t.rspec_opts = '--color --backtrace'
    t.rspec_opts << " --seed #{ENV['SEED']}" if ENV['SEED']
  end

  desc 'Run browser specs'
  RSpec::Core::RakeTask.new(:browser) do |t|
    t.pattern    = ENV['SPEC'] || "spec/browser"
    t.ruby_opts  = "-Ispec/browser"
    t.rspec_opts = '--color --backtrace'
    t.rspec_opts << " --seed #{ENV['SEED']}" if ENV['SEED']
  end
end
