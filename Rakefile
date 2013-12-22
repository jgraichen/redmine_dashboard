require 'yaml'
require 'fileutils'
require 'rubygems'
require 'bundler'
require 'logger'

Bundler.require :default, :development, :assets

require 'rspec/core/rake_task'
require 'sprockets/standalone'

#
# Dashboard tasks
#
DEFAULT_REDMINE_VERSION = '2.4.1'

class Redmine
  attr_reader :version, :path

  def initialize(opts = {})
    @version = opts.delete(:version) { |_| ENV['REDMINE_VERSION'] || DEFAULT_REDMINE_VERSION }
    @path    = File.expand_path "./tmp/redmine/#{@version}", Dir.pwd
  end

  def downloaded?
    File.exists? File.join(path, 'Gemfile')
  end

  def database_config(env)
    {'pool' => 5, 'timeout' => 5000, 'adapter' => 'mysql2', 'database' => "rdb_#{version.gsub('.', '_')}_#{env}"}
  end

  def svn_url
    "http://svn.redmine.org/redmine/#{version == 'master' ? 'trunk' : "tags/#{version}"}"
  end

  def clean
    FileUtils.rm_rf path if File.exists? path
    FileUtils.mkdir_p path
  end

  def exec(*args)
    Dir.chdir path do
      ::Bundler.with_clean_env do
        Redmine.exec *args
      end
    end
  end

  def ruby(*args)
    exec %w(ruby -S), *args
  end

  def bx(*args)
    ruby %w(bundle exec), *args
  end

  class << self
    def exec(*args)
      STDOUT.puts "+ #{args.flatten.join ' '}"
      unless system(*args.flatten)
        raise RuntimeError, "Command failed: #{args.flatten.join ' '}"
      end
    end
  end
end

def force?
  !!ENV['FORCE']
end

RM = Redmine.new

task :default => :spec
task :spec => [:setup, :update, :'assets:compile', :'spec:all']

namespace :spec do
  desc 'Run unit, plugin and integration specs'
  task :all => [:unit, :plugin, :browser]

  desc 'Run unit specs (Testing isolated dashboard components)'
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern    = "spec/unit/**/*_spec.rb"
    t.ruby_opts  = "-Ispec/unit -Ilib"
    t.rspec_opts = "--color --backtrace"
  end

  desc 'Run plugin specs (Testing within redmine application)'
  Class.new(RSpec::Core::RakeTask) do
    def run_task(*args)
      Bundler.with_clean_env { Dir.chdir(RM.path) { super }}
    end
  end.new(:plugin) do |t|
    t.pattern    = "#{RM.path}/spec/plugin/**/*_spec.rb"
    t.ruby_opts  = "-I#{RM.path}/spec/plugin"
    t.rspec_opts = "--color --backtrace"
  end

  desc 'Run browser specs'
  Class.new(RSpec::Core::RakeTask) do
    def run_task(*args)
      Bundler.with_clean_env { Dir.chdir(RM.path) { super }}
    end
  end.new(:browser) do |t|
    t.pattern    = "#{RM.path}/spec/integration/**/*_spec.rb"
    t.ruby_opts  = "-I#{RM.path}/spec/integration"
    t.rspec_opts = "--color --backtrace"
  end
end

desc 'Setup project environment'
task :setup => %w(redmine:install)

desc 'Update project environment'
task :update => %w(redmine:update)

desc 'Start local redmine server'
task :server => :setup do |t, args|
  RM.bx %w(rails server), args
end
task :s => %w(server)

desc 'Compile JS/CSS assets'
Sprockets::Standalone::RakeTask.new do |t, sprockets|
  t.assets  = %w(stylesheets/rdb.css javascripts/rdb.js *.png *.jpg *.gif)
  t.sources = %w(app/assets vendor/assets)
  t.output  = File.expand_path('../assets', __FILE__)

  require 'stylus/sprockets'
  Stylus.setup sprockets

  # sprockets.js_compressor  = :uglifier
  # sprockets.css_compressor = :sass
end

namespace :redmine do
  desc 'Download RM'
  task :download do
    if RM.downloaded? && !force?
      puts "Redmine #{RM.version} already downloaded. Use `redmine:clean` or FORCE=1 to force redownloaded."
    end
    if !RM.downloaded? || force?
      RM.clean
      RM.exec %w(svn export --quiet --force), RM.svn_url, '.'
      RM.exec %w(ln -s), Dir.pwd, 'plugins/redmine_dashboard'
      RM.exec %w(mkdir -p), 'public/plugin_assets'
      RM.exec %w(ln -s), File.join(Dir.pwd, 'assets'), 'public/plugin_assets/redmine_dashboard_linked'
      RM.exec %w(ln -s), File.join(Dir.pwd, 'spec'), '.'
      RM.exec %w(sed -i -e), "s/.*gem [\"']capybara[\"'].*//g", "Gemfile"
    end
  end

  desc 'Configure RM'
  task :config => :download do
    config = {}
    if File.exists? File.join(RM.path, 'config/database.yml')
      begin
        config = YAML.load_file File.join(RM.path, 'config/database.yml')
      rescue => e
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

  desc 'Install RM'
  task :install => :config do
    unless File.exist? File.join(RM.path, '.installed') || force?
      Rake::Task['redmine:bundle'].invoke

      RM.bx %w(rake generate_secret_token)
      RM.bx %w(rake db:create:all)

      Rake::Task['redmine:migrate'].invoke
      Rake::Task['redmine:prepare'].invoke

      FileUtils.touch File.join(RM.path, '.installed')
    else
      puts "Redmine #{RM.version} already installed. Use `redmine:clean` to delete redmine and reinstall or FORCE=1 to force install steps."
    end
  end

  desc 'Update RM by running bundle install and database migrations'
  task :update => [:install, :bundle, :migrate, :prepare]

  task :bundle do
    tries = 0
    begin
      RM.exec %w(bundle install --without rmagick)
    rescue => e
      STDERR.puts 'bundle install failed. Retry...'
      retry if (tries += 1) < 5
    end
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
end
