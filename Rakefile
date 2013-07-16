#
#

BASE = Dir.getwd

def version; ENV["REDMINE_VERSION"] || "2.3.2" end
def tarname; "#{version}.tar.gz" end
def tar; "#{BASE}/tmp/#{tarname}" end
def path; "#{BASE}/tmp/redmine-#{version}"end
def bundle_path; "#{BASE}/tmp/bundle" end
def bx(*attrs); exec *(['bundle', 'exec'] + attrs) end
def bxrake(*attrs); bx *(['rake'] + attrs) end

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

namespace :redmine do
  desc 'Install redmine to tmp dir.'
  task :install => [ :download ] do
    unless_done('install', 1) do
      puts "Install redmine to '#{path}'..."
      Dir.chdir 'tmp' do
        exec 'tar', 'xf', tar
        Dir.chdir path do
          exec 'cp', "#{BASE}/spec/support/database.yml", "#{path}/config"
          exec 'rm', "#{path}/plugins/redmine_dashboard" rescue true
          exec 'ln', '-s', BASE, "#{path}/plugins/"
          exec 'bundle', 'install', '--path', bundle_path
        end
      end
      puts
    end
  end

  desc 'Setup and initialize redmine.'
  task :setup => [ :install ] do
    unless_done('setup', 1) do
      puts "Setup redmine in '#{path}'..."
      Dir.chdir path do
        bxrake 'db:migrate'
        bxrake 'redmine:load_default_data', 'REDMINE_LANG=en'
        bxrake 'generate_secret_token'
        bxrake 'redmine:plugins:migrate'
      end
      puts
    end
  end

  desc 'Download redmine archive.'
  task :download do
    unless File.exists? tar
      puts "Download redmine to '#{tar}'..."
      exec 'mkdir', '-p', 'tmp'
      Dir.chdir 'tmp' do
        exec 'wget', "https://github.com/edavis10/redmine/archive/#{tarname}"
      end
      puts "Redmine version #{version} downloaded to '#{tar}'."
      puts
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

desc 'Run redmine_dashboard specs.'
task :spec => [ 'redmine:setup' ] do
  Dir.chdir path do
    bx 'rspec', 'plugins/redmine_dashboard/spec'
  end
end

task :default => :spec
