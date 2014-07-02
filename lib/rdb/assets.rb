require 'sprockets'

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
      %w(app/assets/images
         app/assets/stylesheets
         app/assets/javascripts
         vendor/bower).each do |source|
        path = File.expand_path(File.join('../../..', source), __FILE__)
        env.append_path path
      end

      env.logger.level = Logger::DEBUG
    end
  end
end
