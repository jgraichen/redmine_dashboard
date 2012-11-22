require 'method_decorators/decorators/memoize'

class RdbColumn
  extend MethodDecorators
  attr_accessor :board
  attr_reader :name, :options, :id, :board, :statuses

  def initialize(id, name, statuses, options = {})
    @id       = id.to_s
    @name     = name
    @statuses = statuses.is_a?(Array) ? statuses : [statuses]
    @options  = options
  end

  def scope(issue_scope)
    issue_scope.where :status_id => statuses.map(&:id)
  end

  +Memoize
  def issues
    board.issues_for(self)
  end

  def percentage
    all_issue_count = board.issues.select {|i| i.children.empty?}.count
    all_issue_count > 0 ? ((issues.count.to_f / all_issue_count) * 100).round(4) : 0
  end

  def title
    name.is_a?(Symbol) ? I18n.translate(name) : name.to_s.humanize
  end

  def compact?
    !!options[:compact]
  end

  def visible?
    !options[:hide]
  end
end
