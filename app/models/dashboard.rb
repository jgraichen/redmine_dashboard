class Dashboard
  attr_reader :project, :options

  VIEW_MODES = [ :card, :compact ]
  BOARD_MODES = [ :outline, :compact ]

  class EmptyParentIssueError < Exception; end

  def initialize(project)
    @project = project
    @options = { :filters => {} }
  end

  def setup(opts, params)
    options.merge! default_options
    options.merge! opts

    # Init board in sub class
    init if respond_to? :init

    update(params) if params.any?

    # Build board in sub class
    build if respond_to? :build
  end

  def update(params)
    # Update issue view mode
    options[:view] = params[:view].to_sym if params[:view] and Dashboard::VIEW_MODES.include? params[:view].to_sym
    options[:mode] = params[:mode].to_sym if params[:mode] and Dashboard::BOARD_MODES.include? params[:mode].to_sym

    filters.each {|id, filter| filter.update params }
  end

  def default_options
    {
      :view => :card,
      :mode => :outline
    }
  end

  def compact?
    options[:mode] == :compact
  end

  def issue_view
    options[:view]
  end

  def issues_for(column)
    filter column.scope(project.issues)
  end

  def issues
    @issues ||= filter(project.issues)
  end

  def filter(issues)
    issues = filters.inject(issues) {|issues, filter| filter[1].scope issues }
    filters.inject(issues) {|issues, filter| filter[1].filter issues }
  end

  def filter_child_issues(issues)
    issues = filters.inject(issues) do |issues, filter|
      filter[1].apply_to_child_issues? ? filter[1].scope(issues) : issues
    end
    issues = filters.inject(issues) do |issues, filter|
      filter[1].apply_to_child_issues? ? filter[1].filter(issues) : issues
    end
    issues
  end

  def issue_visible?(issue)
    return true if child_issues(issue).any?
    child_parent_issues(issue).any? {|issue| issue_visible? issue}
  end

  def child_issues(issue)
    filter_child_issues(issue.children).select{|issue| issue.children.empty? }
  end

  def child_parent_issues(issue)
    issue.children.select{|issue| issue.children.any? };
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

  # Returns minimized options hash that can be
  # stored in session.
  def session_options
    options
  end

  def id
    self.class.board_type
  end

  def name
    I18n.t :"rdb_#{id}"
  end

  def backlog
    @backlog ||= project.version.first {|version| version.name.downcase == 'backlog' }
  end

  def <<(element)
    element.add_to self
  end

  def filters; @filters ||= {} end
  def columns; @columns ||= [] end
  def groups; @groups ||= [] end

  def add_filter(filter); filters[filter.id.to_sym] = filter end
  def add_column(column); columns << column end
  def add_group(group); groups << group end

  class << self
    def board_type
      @board_type ||= name.downcase.to_sym
    end
  end
end
