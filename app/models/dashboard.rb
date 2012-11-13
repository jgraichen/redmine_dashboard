class Dashboard
  attr_reader :groups, :columns, :project, :options

  VIEW_MODES = [ :card, :compact ]

  def initialize(project, options)
    @project = project
    @options = options || {}
    @groups, @columns = [], []

    init if respond_to? :init
  end

  def type
    self.class.name.downcase
  end

  def name
    I18n.t 'dashboard_' + type
  end

  def abbreviation
    unless @abbreviation
      @abbreviation = '#'
      @project.custom_field_values.each do |f|
        @abbreviation = f.to_s + '-' if f.to_s.length > 0 and f.custom_field.read_attribute(:name).downcase == 'abbreviation'
      end
    end
    @abbreviation
  end

  def <<(element)
    element.board = self
    @groups  << element if element.is_a?(DashboardGroup)
    @columns << element if element.is_a?(DashboardColumn)
  end

  def issues
    unless @issues
      @issues = @project.issues.all
      filter_issues if respond_to? :filter_issues
    end
    @issues
  end

  def accept?(issue)
    @filters.each do |key, proc|
      return false unless proc.nil? or proc.call(issue)
    end
    return true
  end

  def drag_enabled?
    User.current.allowed_to?(:edit_issues, @project)
  end
end
