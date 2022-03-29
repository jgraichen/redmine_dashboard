# frozen_string_literal: true

class RdbDashboard
  attr_reader :project, :options

  VIEW_MODES = %i[card compact].freeze

  def initialize(project, opts, params = nil)
    @project = project
    @options = {filters: {}}

    options.merge! self.class.defaults
    options.merge! opts

    if params[:include_subprojects]
      options[:include_subprojects] = (params[:include_subprojects] == 'true')
    end

    # Init board in sub class
    init if respond_to? :init

    filters.each do |_id, filter|
      filter.values = options[:filters][filter.id] if options[:filters][filter.id]
    end
  end

  def setup(params)
    # Update issue view mode
    options[:view] = params[:view].to_sym if params[:view] && RdbDashboard::VIEW_MODES.include?(params[:view].to_sym)
  end

  def update(params)
    if params[:reset]
      filters.each do |_id, filter|
        filter.values = filter.default_values
      end
      options[:filters] = {}
    else
      filters.each do |_id, filter|
        filter.update params if params
        options[:filters][filter.id] = filter.values
      end
    end
  end

  def issue_view
    options[:view]
  end

  def projects
    @projects ||= Project.where(
        project.project_condition(options[:include_subprojects]),
      )
  end

  def project_ids
    @project_ids ||= projects.pluck(:id)
  end

  def issues
    filter Issue
      .where(project_id: project_ids)
      .includes(:assigned_to, :time_entries, :tracker, :status, :priority, :fixed_version)
  end

  def versions
    @versions ||= begin
      version_ids = project.shared_versions.pluck(:id)

      if options[:include_subprojects]
        version_ids += project.rolled_up_versions.pluck(:id)
      end

      Version.where(id: version_ids.uniq).sorted
    end
  end

  def issue_categories
    @issue_categories ||= IssueCategory.where(project_id: project_ids).distinct
  end

  def trackers
    @trackers ||= Tracker.where(
      id: Tracker.joins(:projects).where(projects: {id: project_ids}).distinct,
    ).sorted
  end

  def assignees
    @assignees ||= Principal.where(
      id: Principal.active.joins(:memberships).where(members: {project_id: project_ids}).distinct,
    ).sorted
  end

  def filter(issues)
    issues = filters.inject(issues) {|issues, filter| filter[1].scope issues }
    filters.inject(issues) {|issues, filter| filter[1].filter issues }
  end

  def abbreviation(project_id)
    project_id ||= project.id

    @abbreviations ||= []
    @abbreviations[project_id] ||= begin
      abbreviation = '#'
      Project.find(project_id).custom_field_values.each do |f|
        if f.to_s.blank? && f.custom_field.read_attribute(:name).downcase == 'abbreviation'
          abbreviation = "#{f}-"
        end
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
    @editable ||= !User.current.allowed_to?(:edit_issues, project).nil?
    if str
      @editable ? str : nil
    else
      @editable
    end
  end

  def filters
    @filters ||= HashWithIndifferentAccess.new
  end

  def groups
    @groups ||= HashWithIndifferentAccess.new
  end

  def group_list
    @group_list ||= []
  end

  class << self
    def board_type
      @board_type ||= name.downcase.to_s.gsub(/^rdb/, '').to_sym
    end

    def defaults
      @defaults ||= load_defaults
    end

    def load_defaults
      config = YAML.load_file File.expand_path('../../config/default.yml', __dir__)

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
