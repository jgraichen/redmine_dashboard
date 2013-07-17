#
# Dashboard tasks
#

task :default => :spec

desc 'Run specs.'
task :spec, [ :opts ] => [ :setup ] do |t, args|
  args.with_defaults :opts => 'plugins/redmine_dashboard/spec'
  Dir.chdir path do
    bx 'rspec', '-I', "#{path}/plugins/redmine_dashboard/spec", args[:opts].to_s
  end
end

desc 'Setup project environment.'
task :setup => [ 'redmine:setup' ] do
  # just for delegation
end

#
# Redmine tasks
#

BASE = Dir.getwd

def version; ENV["REDMINE_VERSION"] || "2.3.2" end
def archive; "#{version}.tar.gz" end

def exec(*attrs)
  puts "+ #{attrs.join(' ')}"
  unless system(*attrs)
    raise StandardError.new "Command failed: #{attrs.join(' ')}"
  end
end

def unless_done(name, version = 1, &block)
  donefile = "#{path}/.rdb-done-#{name}.#{version}"
  envs     = []
  if File.exists? donefile
    envs = IO.read(donefile).split("\n").map{|s|s.strip}
  end
  unless envs.include? RUBY_DESCRIPTION
    yield
    exec "echo '#{RUBY_DESCRIPTION}' >> #{donefile}"
  end
end

def tmpdir; "#{BASE}/tmp" end
def archives_path; "#{tmpdir}/archives" end
def redmines_path; "#{tmpdir}/redmines" end
def databases_path; "#{tmpdir}/databases" end
def bundle_path; "#{tmpdir}/bundle" end
def database_path; "#{databases_path}/#{version}" end
def archive_path; "#{archives_path}/#{archive}" end
def path; "#{redmines_path}/#{version}" end
def bx(*attrs); exec *(['bundle', 'exec'] + attrs) end
def bxrake(*attrs); bx *(['rake'] + attrs) end
def mkpath(*paths); exec *(['mkdir', '-p'] + paths) end
def jruby?; Object.const_defined?(:JRUBY_VERSION) end

namespace :redmine do
  desc 'Install redmine to tmp dir.'
  task :install => [ :download ] do
    unless_done('install', 2) do
      Dir.chdir path do
        # database config
        mkpath database_path
        File.open("#{path}/config/database.yml", 'w') do |file|
          file.write <<-DATABASE
common: &common
  pool: 5
  timeout: 5000
DATABASE
          file.write jruby? ? "  adapter: jdbcpostgresql\n" : "  adapter: postgresql\n"
          file.write "  username: postgres\n" if ENV['TRAVIS']
          file.write <<-DATABASE
test:
  <<: *common
  database: rdb_test_#{version.gsub(/\W+/, '_')}
production:
  <<: *common
  database: rdb_#{version.gsub(/\W+/, '_')}
development:
  <<: *common
  database: rdb_dev_#{version.gsub(/\W+/, '_')}
DATABASE
        end

        exec 'cat', "#{path}/config/database.yml" if ENV['TRAVIS']

        # symlink plugin
        exec 'rm', "#{path}/plugins/redmine_dashboard" if File.exists? "#{path}/plugins/redmine_dashboard"
        exec 'ln', '-s', BASE, "#{path}/plugins/"

        # symlink assets for development mode
        mkpath "#{path}/public/plugin_assets"
        exec 'rm', "#{path}/public/plugin_assets/redmine_dashboard_linked" if File.exists? "#{path}/public/plugin_assets/redmine_dashboard_linked"
        exec 'ln', '-s', "#{BASE}/assets", "#{path}/public/plugin_assets/redmine_dashboard_linked"

        # modify redmine Gemfile
        exec 'sed', '-i', '-e', "s/.*gem [\"']capybara[\"'].*//g", "#{path}/Gemfile"

        # install dependencies
        exec 'bundle', 'install', '--path', bundle_path
      end
      puts
    end
  end

  desc 'Setup and initialize redmine.'
  task :setup => [ :install ] do
    unless_done('setup', 1) do
      Dir.chdir path do
        bxrake 'generate_secret_token'
        bxrake 'db:create:all'
        bxrake 'db:migrate'
        bxrake 'db:migrate', 'RAILS_ENV=test'
        bxrake 'redmine:plugins:migrate'
        bxrake 'redmine:load_default_data', 'REDMINE_LANG=en'
      end
      puts
    end
  end

  task :download do
    unless File.exists? "#{path}/Gemfile"
      unless File.exists? archive_path
        mkpath archives_path
        Dir.chdir archives_path do
          exec 'wget', "https://github.com/edavis10/redmine/archive/#{archive}"
        end
      end
      if File.exists? archive_path
        mkpath path
        exec 'tar', '-C', path, '-xz', '--strip=1', '-f', archive_path
      end
    end
  end

  desc 'Remove installed redmine'
  task :remove do
    exec 'rm', '-rf', path
  end

  desc 'Run local redmine development server'
  task :server => [ :setup ] do
    Dir.chdir path do
      bx 'rails', 'server'
    end
    puts
  end
end
