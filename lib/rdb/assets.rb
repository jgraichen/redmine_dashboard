require 'sprockets'
# require 'sprockets/sass'

require 'sass'
require 'coffee-script'
require 'uglifier'
require 'slim'

require 'rdb/sprockets/directives_processor'
require 'rdb/sprockets/import_processor'
require 'rdb/sprockets/script_processor'
require 'rdb/sprockets/stylesheet_processor'

if Sprockets::VERSION == '2.2.2'
  # mounted sprockets in redmine
  require 'sprockets/sass'
end

if Sprockets::VERSION < '2.2.2'

  # Required for MRI >= 2.0
  # https://github.com/sstephenson/sprockets/commit/cde6bc794a6b418da6009a2a2d05e44c2372eddf
  class Sprockets::DirectiveProcessor
    def directives
      @directives ||= header.lines.each_with_index.map do |line, index|
        if (directive = line[DIRECTIVE_PATTERN, 1])
          name, *args = Shellwords.shellwords(directive)
          if respond_to?("process_#{name}_directive", true)
            [index + 1, name, *args]
          end
        end
      end.compact
    end
  end
end

module Rdb
  module Assets
    def self.setup(env)
      %w(app/assets vendor/assets).each do |source|
        path = File.expand_path(File.join('../../..', source), __FILE__)

        if File.exist?(path) && File.directory?(path)
          path = File.realpath(path)
          env.append_path path
        end
      end

      env.logger.level = Logger::DEBUG

      env.register_mime_type 'text/html', '.slim'
      env.register_mime_type 'text/html', '.html'
      env.register_postprocessor 'text/html', ::Rdb::Sprockets::DirectiveProcessor

      env.register_postprocessor 'text/html', :import_processor do |context, data|
        ::Rdb::Sprockets::ImportProcessor.new(context).process(data)
      end
      env.register_postprocessor 'text/html', :script_processor do |context, data|
        ::Rdb::Sprockets::ScriptProcessor.new(context).process(data)
      end
      env.register_postprocessor 'text/html', :stylesheet_processor do |context, data|
        ::Rdb::Sprockets::StylesheetProcessor.new(context).process(data)
      end

      env.register_engine '.slim', Slim::Template
    end
  end
end
