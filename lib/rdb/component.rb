module Rdb

  #
  #
  module Component
    attr_reader :board

    def initialize(opts = {})
      @board = opts.delete(:board) { raise ArgumentError.new 'board missing.' }
    end
  end
end
