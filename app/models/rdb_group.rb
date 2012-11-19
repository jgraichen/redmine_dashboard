require 'method_decorators/decorators/memoize'

class RdbGroup
  extend MethodDecorators
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
    name.is_a?(Symbol) ? I18n.translate(name) : name.to_s.humanize
  end

  +Memoize
  def accepted_issues(source = nil)
    filter((source ? source : board).issues)
  end

  +Memoize
  def accepted_issue_ids
    accepted_issues.map(&:id)
  end

  def filter(issues)
    issues.select{|i| accept? i}
  end

  +Memoize
  def visible?
    board.columns.values.each do |column|
      next if not column.visible? or column.compact?
      Rails.logger.warn "ISSUE COUNT OF #{id} IN COLUMN #{column.id} => #{issues(column).count}"
      return true if issues(column).count > 0
    end
    false
  end

  def issues(column = nil)
    accepted_issues(column).select{|i| i.children.empty?}
  end
end
