module Rdb

  #
  #
  class Engine
    attr_reader :board

    def initialize(board)
      @board = board
    end

    def issues
      board.context.issues
    end

    class << self
      def lookup(name)
        engines.detect { |klass| klass.name == name }
      end

      def lookup!(name)
        lookup(name).tap do |engine|
          raise NameError.new "No rdb board engine '#{name}' found." unless engine
        end
      end

      def engines
        @engines ||= []
      end
    end
  end
end
