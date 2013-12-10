class Rdb::Taskboard

  #
  #
  class Column
    include ::Rdb::Component
    attr_reader :name, :color, :options

    def initialize(opts = {})
      super

      @name     = opts.delete(:name)     { raise ArgumentError.new 'Name missing.' }
      @color    = opts.delete(:color)    { raise ArgumentError.new 'Color missing.' }
      @options  = opts
    end

    def scope(issues)
      raise NotImplementedError
    end

    def title
      name.is_a?(Symbol) ? I18n.translate(name) : name.to_s
    end

    def issues
      scope board.issues
    end

    def compact?
      !!options[:compact]
    end

    def visible?
      !options[:hide]
    end
  end
end
