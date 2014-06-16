class Rdb::Taskboard

  #
  #
  class Column
    include ::Rdb::Component
    attr_reader :name, :color, :options

    def initialize(engine, opts = {})
      super

      @name     = opts.delete(:name)  { raise ArgumentError.new 'Name missing.' }
      @color    = opts.delete(:color) { nil }
      @options  = opts
    end

    def scope(issues)
      raise NotImplementedError
    end

    def title
      name.is_a?(Symbol) ? I18n.translate(name) : name.to_s
    end

    def issues
      scope engine.issues.includes(:priority).order('enumerations.position DESC')
    end

    def compact?
      !!options[:compact]
    end

    def visible?
      !options[:hide]
    end
  end
end
