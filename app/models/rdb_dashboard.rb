class RdbDashboard
  attr_reader :project, :projects, :project_ids, :options

  VIEW_MODES = [ :card, :compact ]

  def initialize(project, opts, params = nil)
    @project     = project

    @options = { :filters => {} }

    options.merge! self.class.defaults
    options.merge! opts

    if params[:include_subprojects]
      options[:include_subprojects] = (params[:include_subprojects] == 'true')
    end

    reload_projects!

    # Init board in sub class
    init if respond_to? :init

    filters.each do |id, filter|
      filter.values = options[:filters][filter.id] if options[:filters][filter.id]
    end
  end

  def reload_projects!
    if options[:include_subprojects]
      @project_ids = subproject_ids([project.id])
    else
      @project_ids = [project.id]
    end
    @projects = Project.where :id => project_ids
  end

  def subproject_ids(ids)
    ids.inject(ids.dup) do |ids, id|
      ids + subproject_ids(Project.where(:parent_id => id).pluck(:id))
    end.uniq
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

  def issue_view
    options[:view]
  end

  def issues
    filter(Issue.where(:project_id => project_ids))
  end

  def versions
    Version.where :project_id => project_ids
  end

  def issue_categories
    IssueCategory.where :project_id => project_ids
  end

  def trackers
    Tracker.where(:id => projects.map{|p| p.trackers.pluck(:id)}.uniq.flatten)
  end

  def assignees
    Principal.where :id => member_principals.pluck(:user_id)
  end

  def members
    Member.where(:id => projects.map{|p| p.members.map(&:id)}.uniq.flatten)
  end

  def member_principals
    Member.where(:id=> projects.map{|p| p.member_principals.map(&:id)}.uniq.flatten)
  end

  def memberships
    Member.where(:id => projects.map{|p| p.memberships.pluck(:id) }.uniq.flatten)
  end

  def filter(issues)
    issues = filters.inject(issues) {|issues, filter| filter[1].scope issues }
    filters.inject(issues) {|issues, filter| filter[1].filter issues }
  end

  def abbreviation(project_id)
    project_id = project.id unless project_id

    @abbreviations ||= []
    @abbreviations[project_id] ||= begin
      abbreviation = '#'
      Project.find(project_id).custom_field_values.each do |f|
        abbreviation = f.to_s + '-' if f.to_s.length > 0 and f.custom_field.read_attribute(:name).downcase == 'abbreviation'
      end
      abbreviation
    end
  end

  def issue_id(issue)
    if issue.respond_to?(:issue_id)
      issue.issue_id
    else
      abbreviation(issue.project_id) + issue.id.to_s
    end
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
    group_list << group
    groups[group.id.to_s] = group
  end

  def editable?(str = nil)
    @editable ||= !!User.current.allowed_to?(:edit_issues, project)
    str ? (@editable ? str : nil) : @editable
  end

  def filters; @filters ||= HashWithIndifferentAccess.new end
  def groups; @groups ||= HashWithIndifferentAccess.new end
  def group_list; @group_list ||= [] end

  class << self
    def board_type
      @board_type ||= name.downcase.to_s.gsub(/^rdb/, '').to_sym
    end

    def defaults
      @defaults ||= load_defaults
    end

    def load_defaults
      config = YAML.load_file File.expand_path('../../../config/default.yml', __FILE__)

      {
        view: check_opts(config, 'view', :card, :compact),
        include_subprojects: check_opts(config, 'include_subprojects', false, true),
        assignee: check_opts(config, 'assignee', :me, :all),
        version: check_opts(config, 'version', :latest, :all),
        hide_done: check_opts(config, 'hide_done', false, true),
        change_assignee: check_opts(config, 'change_assignee', false, true)
      }
    end

    def check_opts(options, name, *values)
      value = options.fetch(name) { return values.first }
      values.each do |val|
        return val if val == value || val.to_s == value
      end

      values.first
    end
  end
end
