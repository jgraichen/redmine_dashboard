class DashboardGroup
  attr_accessor :name, :id, :param
  
  def initialize(name, param, id, &filter) 
    @name = name
    @id = param.to_s+'-'+id.to_s
    @param = param.to_s+'='+id.to_s
    @filter = filter
  end
  
  def accept?(issue)
    return true if @filter.nil?
    
    @filter.call(issue)
  end
end