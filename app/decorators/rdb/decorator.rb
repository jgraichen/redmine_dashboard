module Rdb
  class Decorator
    attr_reader :object

    def initialize(object)
      @object = object
    end

    class << self
      def new(object)
        if object.respond_to?(:each)
          object.each.map{|o| super o }
        else
          super object
        end
      end
    end
  end
end
