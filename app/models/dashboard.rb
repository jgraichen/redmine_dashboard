class Dashboard
  attr_reader :groups, :columns
  
  def initialize(project, options = {})
    @project = project
    @groups, @columns = [], []
    @grag_enabled = options[:drag_enabled] || true
  end
  
  def <<(element)
    @groups  << element if element.is_a?(DashboardGroup)
    @columns << element if element.is_a?(DashboardColumn)
  end
  
  def add_column(name, params = {}, &block)
    @columns << DashboardColumn.new(name, params, block)
  end
  
  def add_group(name, params = {}, &block)
    @groups << DashboardGroup.new(name, params, block)
  end
  
  def accept?(issue)
    @filters.each do |key, proc|
      return false unless proc.nil? or proc.call(issue)
    end 
    return true
  end
  
  def drag_enabled?
    !!@drag_enabled
  end
end