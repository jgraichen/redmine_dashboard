#
# Dashboard tasks
#

def exec(*attrs)
  attrs = %w(./redmine.sh) + attrs
  # puts "+ #{attrs.join(' ')}"
  unless system(*attrs)
    raise StandardError.new "Command failed: #{attrs.join(' ')}"
  end
end

task :default => :spec

desc 'Run specs.'
task :spec, [ :opts ] => [ :setup ] do |t, args|
  args.with_defaults :opts => 'spec'
  exec 'spec', args.opts
end

desc 'Setup project environment.'
task :setup => [ 'redmine:install' ] do end

desc 'Start redmine development server.'
task :server => [ 'redmine:server' ] do end
task :s => [ 'redmine:server' ] do end

task :ci => [ :setup ] do
  exec 'ci'
end

namespace :redmine do
  desc 'Download Redmine'
  task :download do
    exec 'download'
  end

  desc 'Install Redmine'
  task :install => [ :download ] do
    exec 'install'
  end

  desc 'Update Redmine'
  task :update => [ :install ] do
    exec 'update'
  end

  desc 'Run local redmine development server'
  task :server => [ :install ] do
    exec 'server'
  end
end
