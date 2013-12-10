class Rdb::Taskboard

  #
  #
  class Group
    include ::Rdb::Component
    attr_reader :name, :options

    def initialize(opts = {})
      @name     = opts.delete(:name) { raise ArgumentError.new 'Name missing.' }
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

    def visible?
      @visible ||= begin
        board.columns.any? do |column|
          column.visible? && !column.compact? && column.issues.any?
        end
      end
    end
  end
end
