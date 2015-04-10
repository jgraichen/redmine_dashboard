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

namespace :tx do
  desc 'Fetch translations from Transifex.'
  task :pull do
    require 'inifile'
    require 'transifex'

    auth = IniFile.load(File.expand_path('~/.transifexrc')).to_h
    conf = IniFile.load(File.expand_path('../.tx/config', __FILE__)).to_h

    host = conf.delete('main')['host']
    user = auth[host]['username']
    pass = auth[host]['password']

    transifex = Transifex::Client.new username: user, password: pass
    conf.each_pair do |key, cfg|
      name, slug = key.split('.', 2)

      project  = transifex.project(name)
      resource = project.resource(slug)
      locales  = project.details[:teams]

      locales.each do |locale|
        code = locale.gsub('_', '-')
        file = cfg['file_filter'].gsub('<lang>', code)
        done = resource.stats[locale][:completed].to_i

        if !File.exist?(file) && done < 80
          puts "Skip #{code} [only #{done}% completed]"
          next
        end

        yaml = YAML.load resource.translation(locale)[:content]

        # Translate underscore locale to dashed in YAML root
        data = {code => yaml[locale]}

        if File.exist?(file)
          puts "Update #{code} ..."
        else
          puts "Add #{code} ..."
        end

        IO.write file, YAML.dump(data, line_width: -1)
      end
    end
  end
end
