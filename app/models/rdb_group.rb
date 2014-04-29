class RdbGroup
  attr_accessor :board
  attr_reader :name, :options, :id

  def initialize(id, name, options = {})
    @id    = id.to_s
    @name  = name

    @options = default_options
    @options[:accept] = options[:accept] if options[:accept].respond_to? :call
  end

  def default_options
    {}
  end

  def accept?(issue)
    return true if options[:accept].nil?
    options[:accept].call(issue)
  end

  def title
    name.is_a?(Symbol) ? I18n.translate(name) : name.to_s
  end

  def accepted_issues(source = nil)
    @accepted_issues ||= filter((source ? source : board).issues)
  end

  def accepted_issue_ids
    @accepted_issue_ids ||= accepted_issues.map(&:id)
  end

  def filter(issues)
    issues.select{|i| accept? i}
  end

  def visible?
    @visible ||= catch(:visible) do
      board.columns.values.each do |column|
        next if not column.visible? or column.compact?
        throw :visible, true if filter(column.issues).count > 0
      end
      false
    end
  end

  def issue_count
    filter(@board.issues).count.to_i
  end
end
