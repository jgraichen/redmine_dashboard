require 'yaml'
require 'fileutils'
require 'rubygems'
require 'bundler'
require 'logger'

require 'rspec/core/rake_task'

require_relative './redmine'

def force?
  ENV.key? 'FORCE'
end

RM = RdbRedmine.new

task default: [:install, :update, :compile, :spec]

desc 'Run all specs (alias for spec:all)'
task spec: 'spec:all'

namespace :spec do
  desc 'Run unit, plugin and browser specs'
  task all: [:unit, :plugin, :browser]

  desc 'Run unit specs (Testing isolated dashboard components)'
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern    = ENV['SPEC'] || 'spec/unit/**/*_spec.rb'
    t.ruby_opts  = '-Ispec/unit -Ilib'
    t.rspec_opts = '--color --backtrace'
    t.rspec_opts << " --seed #{ENV['SEED']}" if ENV['SEED']
  end

  desc 'Run plugin specs (Testing within redmine application)'
  RSpec::Core::RakeTask.new(:plugin) do |t|
    t.pattern    = ENV['SPEC'] || "spec/plugin/**/*_spec.rb"
    t.ruby_opts  = "-Ispec/plugin"
    t.rspec_opts = '--color --backtrace'
    t.rspec_opts << " --seed #{ENV['SEED']}" if ENV['SEED']
  end

  desc 'Run browser specs'
  RSpec::Core::RakeTask.new(:browser) do |t|
    t.pattern    = ENV['SPEC'] || "spec/browser/**/*_spec.rb"
    t.ruby_opts  = "-Ispec/browser"
    t.rspec_opts = '--color --backtrace'
    t.rspec_opts << " --seed #{ENV['SEED']}" if ENV['SEED']
  end
end
task ci: :spec

desc 'Setup project environment (alias for redmine:install)'
task install: %w(redmine:install)

desc 'Update project environment (alias for redmine:update)'
task update: %w(redmine:update)

desc 'Start local redmine server (aliases: `s`)'
task server: :install do |_, args|
  RM.bx %w(rails server), args
end
task s: 'server'

desc <<-DESC.gsub(/^ {2}/, '')
  Cleanup project directory. This removes all installed
  redmines as well as precompiled assets.
DESC
task :clean do
  %w(tmp).each do |dir|
    FileUtils.rm_rf dir if File.directory?(dir)
  end
end

task :compile do
  RdbRedmine.exec %w(make install-deps)
  RdbRedmine.exec %w(make min)
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

namespace :redmine do
  desc <<-DESC.gsub(/^ {4}/, '')
    Download Redmine. That includes exporting SVN tag,
    linking plugin and plugin specs and do necessary
    changed to Redmine\'s Gemfile.
  DESC
  task :download do
    if File.exist?(File.join(RM.path, '.downloaded')) && !force?
      puts "Redmine #{RM.version} already downloaded. "\
           'Use `redmine:clean` or FORCE=1 to force redownloaded.'
    else
      RM.clean
      RM.exec %w(svn export --quiet --force), RM.svn_url, '.'
      RM.exec %w(ln -s), Dir.pwd, 'plugins/redmine_dashboard'
      RM.exec %w(mkdir -p), 'public/plugin_assets'
      RM.exec %w(ln -s), File.join(Dir.pwd, 'assets'),
        'public/plugin_assets/redmine_dashboard_linked'
      RM.exec %w(ln -s), File.join(Dir.pwd, 'spec'), '.'

      # Adjust capybara version requirements as redmine locks to ~> 2.1.0
      # but rspec 3 requires >= 2.2
      RM.exec %w(sed -i -e),
        "s/.*gem [\"']capybara[\"'].*/gem 'capybara', '~> 2.3'/g", 'Gemfile'

      FileUtils.touch File.join(RM.path, '.downloaded')
    end
  end

  desc <<-DESC.gsub(/^ {4}/, '')
    Configure Redmine. A database config will be generated
    using mysql2 gem and the `rdb_development` database for
    the `development` environment. Already existing
    configuration will be preserved except for the `test`
    environment.
  DESC
  task config: :download do
    config = {}
    if File.exist? File.join(RM.path, 'config/database.yml')
      begin
        config = YAML.load_file File.join(RM.path, 'config/database.yml')
      rescue => e
        warn e
      end
    end

    config['test'] = RM.database_config(:test)
    %w(production development).each do |env|
      config[env] = RM.database_config(env) unless config[env]
    end

    File.open(File.join(RM.path, 'config/database.yml'), 'w') do |f|
      f.write YAML.dump config
    end
  end

  desc <<-DESC.gsub(/^ {4}/, '')
    Install Redmine. This task will run `bundle install`,
    generate secret token, create databases as well as
    migrate and prepare them. This task will only run once
    unless forced. Use `update` for updating after new gems
    or database migrations.
  DESC
  task install: :config do
    if File.exist?(File.join(RM.path, '.installed')) && !force?
      puts "Redmine #{RM.version} already installed. Use `redmine:clean` to "\
           'delete redmine and reinstall or FORCE=1 to force install steps.'
    else
      Rake::Task['redmine:bundle'].invoke

      RM.bx %w(rake generate_secret_token)
      RM.bx %w(rake db:create:all)

      Rake::Task['redmine:migrate'].invoke
      Rake::Task['redmine:prepare'].invoke

      FileUtils.touch File.join(RM.path, '.installed')
    end
  end

  desc <<-DESC.gsub(/^ {4}/, '')
    Update Redmine. This runs `bundle install` and migrate
    and prepare databases.
  DESC
  task update: [:install, :bundle, :migrate, :prepare]

  task :bundle do
    RM.exec %w(rm -f Gemfile.lock)
    RM.exec %w(bundle install --without rmagick --jobs=3 --retry=3)
  end

  task :migrate do
    RM.bx %w(rake db:migrate)
    RM.bx %w(rake redmine:plugins:migrate)
  end

  task :prepare do
    RM.bx %w(rake db:test:prepare)
  end

  desc 'Clean redmine directory'
  task :clean do
    RM.clean
  end

  task :exec, [:cmd] do |_, args|
    puts RM.bx args.cmd
  end
end
