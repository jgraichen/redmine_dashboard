class DashboardColumn
  attr_accessor :name, :id, :drag_enabled
  
  def initialize(name, id, &filter)
    @name = name
    @id = id
    @filter = filter
    @drag_enabled = true
  end
  
  def accept?(issue)
    @filter.call(issue)
  end
end