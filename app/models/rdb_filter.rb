class RdbFilter
  attr_accessor :board
  attr_reader :id

  def initialize(id)
    @id    = id.to_sym
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
    @values = values.select {|value| valid_value? value }
    @values = default_values if @values.empty? and not allow_no_values?
  end

  def valid_value?(value)
    true
  end

  def allow_no_values?
    false
  end

  def title
    values.join
  end

  def to_options
    [ ]
  end

  def scope(scope)
    scope
  end

  def filter(issues)
    issues
  end

  def apply_to_child_issues?
    false
  end

  def update(params)

  end
end
