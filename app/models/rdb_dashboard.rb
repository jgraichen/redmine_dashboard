class RdbDashboard
  attr_reader :project, :options

  VIEW_MODES = [ :card, :compact ]

  def initialize(project, opts, params = nil)
    @project = project
    @options = { :filters => {} }

    options.merge! default_options
    options.merge! opts

    # Init board in sub class
    init if respond_to? :init

    filters.each do |id, filter|
      filter.values = options[:filters][filter.id] if options[:filters][filter.id]
    end
  end

  def setup(params)
    # Update issue view mode
    options[:view] = params[:view].to_sym if params[:view] and RdbDashboard::VIEW_MODES.include? params[:view].to_sym
  end

  def update(params)
    if params[:reset]
      filters.each do |id, filter|
        filter.values = filter.default_values
      end
      options[:filters] = {}
    else
      filters.each do |id, filter|
        filter.update params if params
        options[:filters][filter.id] = filter.values
      end
    end
  end

  def default_options
    { :view => :card }
  end

  def issue_view
    options[:view]
  end

  def issues
    @issues ||= filter(project.issues)
  end

  def filter(issues)
    issues = filters.inject(issues) {|issues, filter| filter[1].scope issues }
    filters.inject(issues) {|issues, filter| filter[1].filter issues }
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

  def id
    self.class.board_type
  end

  def name
    I18n.t :"rdb_#{id}"
  end

  def add_filter(filter)
    filter.board = self
    filters[filter.id.to_s] = filter
  end

  def add_group(group)
    group.board = self
    groups[group.id.to_s] = group
  end

  def editable?(str = nil)
    @editable ||= !!User.current.allowed_to?(:edit_issues, project)
    str ? (@editable ? str : nil) : @editable
  end

  def filters; @filters ||= HashWithIndifferentAccess.new end
  def groups; @groups ||= HashWithIndifferentAccess.new end

  class << self
    def board_type
      @board_type ||= name.downcase.to_s.gsub(/^rdb/, '').to_sym
    end
  end
end
