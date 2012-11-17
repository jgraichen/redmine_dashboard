class RdbDashboard::Column
  attr_reader :name, :options, :id, :board

  def initialize(id, name, options = {})
    @id = id.to_s
    @name = name

    @options = default_options
    @options[:scope] = options[:scope] if options[:scope].respond_to? :call
    @options[:hide]  = options[:hide] ? true : false
    @options[:value] = options[:value] if options[:value]
  end

  def add_to(board)
    @board = board
    board.add_column self
  end

  def default_options
    {}
  end

  def show_issues?

  end

  def value
    options[:value]
  end

  def scope(issue_scope)
    return issue_scope if options[:scope].nil?
    options[:scope].call(issue_scope)
  end

  def issues
    @issues ||= board.issues_for(self).select {|i| i.children.empty?}
  end

  def percentage
    all_issue_count = board.issues.select {|i| i.children.empty?}.count
    all_issue_count > 0 ? ((issues.count.to_f / all_issue_count) * 100).round(4) : 0
  end

  def title
    name.is_a?(Symbol) ? I18n.translate(name) : name.to_s.humanize
  end

  def hide?
    options[:hide]
  end
end
