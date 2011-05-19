class Dashboard
  attr_reader :groups, :columns
  
  def initialize(options={})
    @groups, @columns = [], []
    @grag_enabled = options[:drag_enabled] || true
  end
  
  def <<(element)
    @groups  << element if element.is_a?(DashboardGroup)
    @columns << element if element.is_a?(DashboardColumn)
  end
  
  def drag_enabled?
    !!@drag_enabled
  end
end