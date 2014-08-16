require 'pathname'
#
# Dashboard tasks
#
DEFAULT_REDMINE_VERSION = '2.5.2'

class RdbRedmine
  attr_reader :version, :path

  def initialize(opts = {})
    @version = opts.delete(:version) do |_|
      ENV['REDMINE_VERSION'] || DEFAULT_REDMINE_VERSION
    end

    @path = Pathname.new File.expand_path("../tmp/redmine/#{@version}", __FILE__)
  end

  def join(*path)
    self.path.join *path.flatten
  end

  def downloaded?
    self.path.join('Gemfile').exist?
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
    path.rmtree if path.exist?
    path.mkpath
  end

  def exec(*args, &block)
    Dir.chdir path do
      ::Bundler.with_clean_env do
        block ? block.call : self.class.exec(*args)
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

    def join(*path)
      instance.join *path.flatten
    end

    def instance
      @default ||= new
    end
  end
end
