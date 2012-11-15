class Dashboard::Filter
  attr_reader :id, :board

  def initialize(id)
    @id = id.to_sym
  end

  def add_to(board)
    @board = board
    @board.add_filter self
    @values = @board.options[:filters][id] || default_values
  end

  def default_options
    {}
  end

  def values
    @values ||= default_values
  end

  def default_values
    [ ]
  end

  def value
    values.first
  end

  def value=(value)
    self.values = value ? [ value ] : []
  end

  def values=(values)
    values = [ values ] unless values.is_a?(Array)
    @values = values.select {|value| accept? value }
    @board.options[:filters][id] = @values
  end

  def accept?(value)
    true
  end

  def title
    values.join
  end

  def to_options
    [ ]
  end

  def update(params)

  end
end
