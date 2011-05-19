class DashboardGroup
  attr_accessor :name, :id
  
  def initialize(name, id, &filter) 
    @name = name
    @id = id
    @filter = filter
  end
  
  def accept?(issue)
    return true if @filter.nil?
    
    @filter.call(issue)
  end
end