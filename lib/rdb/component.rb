module Rdb

  #
  #
  module Component
    attr_reader :engine

    def initialize(engine, opts = {})
      @engine = engine
    end
  end
end
