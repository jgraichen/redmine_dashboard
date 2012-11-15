class Dashboard::Column
  attr_reader :name, :options, :id

  def initialize(id, name, options = {})
    @id = id.to_s.to_sym
    @name = name

    @options = default_options
    @options[:accept] = options[:accept] if options[:accept].respond_to? :call
    @options[:hide] = options[:hide] ? true : false
  end

  def add_to(board)
    board.add_column self
  end

  def default_options
    {}
  end

  def accept?(issue)
    return true if options[:accept].nil?
    options[:accept].call(issue)
  end

  def filter(issues)
    issues.select {|issue| accept? issue }
  end

  def title
    name.is_a?(Symbol) ? I18n.translate(name) : name.to_s.humanize
  end

  def hide?
    options[:hide]
  end
end
