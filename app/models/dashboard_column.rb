class DashboardColumn
  attr_reader :name, :params, :id
  
  def initialize(id, name, params, &filter)
    @name = name
    @id = id
    @params = params
    @filter = filter
  end
  
  def id
    @id.to_s
  end
  
  def accept?(issue)
    @filter.call(issue)
  end
  
  def title
    name.is_a?(Symbol) ? I18n.translate(name) : name.to_s
  end
end