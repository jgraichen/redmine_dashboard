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
