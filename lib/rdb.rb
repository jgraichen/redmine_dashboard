module Rdb
  require 'rdb/engine'
  require 'rdb/component'

  require 'rdb/taskboard'
  require 'rdb/taskboard/group'
  require 'rdb/taskboard/column'
  require 'rdb/taskboard/columns/status'
end

require 'sprockets'

if Sprockets::VERSION < '2.2.2'
  # Required for MRI >= 2.0
  # https://github.com/sstephenson/sprockets/commit/cde6bc794a6b418da6009a2a2d05e44c2372eddf
  class Sprockets::DirectiveProcessor
    def directives
      @directives ||= header.lines.each_with_index.map { |line, index|
        if directive = line[DIRECTIVE_PATTERN, 1]
          name, *args = Shellwords.shellwords(directive)
          if respond_to?("process_#{name}_directive", true)
            [index + 1, name, *args]
          end
        end
      }.compact#.tap{|d| p d }
    end
  end
end
