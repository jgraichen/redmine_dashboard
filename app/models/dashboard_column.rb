class DashboardColumn
  attr_accessor :name, :id, :drag_enabled, :param
  
  def initialize(name, param, id, &filter)
    @name = name
    @id = param.to_s+'-'+id.to_s
    @param = param.to_s+'='+id.to_s
    @filter = filter
    @drag_enabled = true
  end
  
  def accept?(issue)
    @filter.call(issue)
  end
end