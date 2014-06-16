module Rdb
  class Engine
    # Database Board Record.
    #
    attr_reader :board

    def initialize(board)
      @board = board
    end

    def issues
      board.issues
    end

    def name
      board.name
    end

    class << self
      attr_accessor :name

      def lookup(name)
        if (engine = engines.detect { |klass| klass.name == name })
          engine
        else
          begin
            name.constantize
          rescue NameError
            nil
          end
        end
      end

      def lookup!(name)
        lookup(name).tap do |engine|
          raise NameError.new "No rdb board engine '#{name}' found.\nAvailable engines: #{engines.map(&:name).join(', ')}" unless engine
        end
      end

      def engines
        @engines ||= []
      end
    end
  end
end
