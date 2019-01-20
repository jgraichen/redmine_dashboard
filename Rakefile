require 'yaml'
require 'fileutils'
require 'rubygems'
require 'bundler'
require 'logger'

require 'rspec/core/rake_task'


task default: [:spec]

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern    = ENV['SPEC'] || "spec/**/*_spec.rb"
  t.ruby_opts  = "-Ispec"
  t.rspec_opts = '--color --backtrace'
  t.rspec_opts << " --seed #{ENV['SEED']}" if ENV['SEED']
end
