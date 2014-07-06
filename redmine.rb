#
# Dashboard tasks
#
DEFAULT_REDMINE_VERSION = '2.5.2'

class Redmine
  attr_reader :version, :path

  def initialize(opts = {})
    @version = opts.delete(:version) do |_|
      ENV['REDMINE_VERSION'] || DEFAULT_REDMINE_VERSION
    end

    @path = File.expand_path "../tmp/redmine/#{@version}", __FILE__
  end

  def downloaded?
    File.exist? File.join(path, 'Gemfile')
  end

  def database_config(env)
    table = if env == 'development'
              'rdb_development'
            else
              "rdb_#{version.gsub('.', '_')}_#{env}"
            end

    {
      'pool' => 5,
      'timeout' => 5000,
      'adapter' => 'mysql2',
      'database' => table
    }
  end

  def svn_url
    if version == 'master'
      'http://svn.redmine.org/redmine/trunk'
    else
      "http://svn.redmine.org/redmine/tags/#{version}"
    end
  end

  def clean
    FileUtils.rm_rf path if File.exist? path
    FileUtils.mkdir_p path
  end

  def exec(*args)
    Dir.chdir path do
      ::Bundler.with_clean_env do
        Redmine.exec(*args)
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
      STDOUT.puts "#{Dir.getwd} $ #{args.flatten.join ' '}"

      return if system(*args.flatten)

      raise "Command failed: #{args.flatten.join ' '}"
    end
  end
end
