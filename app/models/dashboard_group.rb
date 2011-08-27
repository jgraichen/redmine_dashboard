class DashboardGroup
  attr_reader :name, :params, :id
  
  def initialize(id, name, params = {}, &filter) 
    @id = id
    @name = name
    @params = params
    @filter = filter
  end
  
  def accept?(issue)
    return true if @filter.nil?
    
    @filter.call(issue)
  end
  
  def id 
    @id.to_s
  end
  
  def title
    name.is_a?(Symbol) ? I18n.translate(name) : name.to_s
  end
end