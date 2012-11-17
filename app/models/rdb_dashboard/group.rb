class RdbDashboard::Group
  attr_reader :name, :options, :id, :board

  def initialize(id, name, options = {})
    @id = id.to_s
    @name = name

    @options = default_options
    @options[:accept] = options[:accept] if options[:accept].respond_to? :call
  end

  def add_to(board)
    @board = board
    board.add_group self
  end

  def default_options
    {}
  end

  def accept?(issue)
    return true if options[:accept].nil?
    options[:accept].call(issue)
  end

  def title
    name.is_a?(Symbol) ? I18n.translate(name) : name.to_s.humanize
  end

  def accepted_issues
    @issues ||= filter(board.issues)
  end

  def accepted_issue_ids
    @issue_ids ||= accepted_issues.map(&:id)
  end

  def filter(issues)
    issues.select{|i| accept? i}
  end

  def visible?
    issues.count > 0
  end

  def parent_issues
    return [] if board.compact?
    accepted_issues.select{|i| (!accepted_issue_ids.include?(i.parent_id) or i.parent_id == nil) and i.children.any?}
  end

  def issues
    if board.compact?
      accepted_issues.select{|i| i.children.empty?}
    else
      accepted_issues.select{|i| i.parent_id == nil and i.children.empty?}
    end
  end
end
