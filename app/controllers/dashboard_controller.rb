class DashboardController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :setup

  VIEW_MODES = {
    :card => 'issue_card',
    :list => 'issue_item'
  }

  def index
    if !params[:issue].nil? and @edit_enabled
      @issue = Issue.find(params[:issue]);

      if params[:status] == 'done'
        show_done_form(@issue)
        return
      else
        update_issue(@issue, params)
      end
    end

    load_issues
    render '_dashboard', :layout => false if request.xhr?
  end

  def show_done_form(issue)
    load_issue_resolutions(@issue)
    @done_statuses = []
    IssueStatus.find(:all).each do |s|
      @done_statuses << [s.name, s.id.to_s] if s.is_closed?
    end
    if request.xhr?
      render '_dashboard_done', :layout => false
    else
      render 'index_done'
    end
  end

  def update_issue(issue, attributes)
    status = IssueStatus.find_by_id(attributes[:status])
    old_status = issue.status
    old_done_ratio = issue.done_ratio
    allowed_statuses = issue.new_statuses_allowed_to(User.current)

    # check if user is allowed to change ticket status and ticket status
    # is not the same as before
    if (User.current.admin? or allowed_statuses.include?(status)) and status != old_status
      load_issue_resolutions(issue)
      resolution_field = issue_resolution_field(issue)

      issue.init_journal(User.current, attributes[:notes] || nil)

      issue.status_id = status.id
      issue.done_ratio = attributes[:done_ratio].to_i if attributes[:done_ratio]
      issue.assigned_to_id = User.current.id if @options[:change_assignee] && issue.assigned_to_id != User.current.id

      if !resolution_field.nil? and resolution_field.value != attributes[:resolution].to_s
        issue.custom_field_values = { resolution_field.custom_field.id => attributes[:resolution].to_s }
      end

      return issue.save
    end
    false
  end

private
  def setup
    @options = {
      :view => :card,
      :owner => :me,
      :version => find_version || :all,
      :tracker => 'all',
      :group => 'none',
      :change_assignee => false,
      :hide_done => false
    }

    if params[:reset].nil?
      @options = session['dashboard_'+@project.id.to_s] if session['dashboard_'+@project.id.to_s].is_a?(Hash)

      @options[:view] = params[:view].to_sym    if !params[:view].nil? and !VIEW_MODES[params[:view].to_sym].nil?
      @options[:owner] = params[:owner].to_sym  if params[:owner] == 'all' or params[:owner] == 'me'
      @options[:version] = params[:version]     unless params[:version].nil?
      @options[:tracker] = params[:tracker]     unless params[:tracker].nil?
      @options[:group] = params[:group]         unless params[:group].nil?
      @options[:change_assignee] = (params[:change_assignee] == "1" ? true : false) unless params[:change_assignee].nil?
      @options[:hide_done] = (params[:hide_done] == "1" ? true : false) unless params[:hide_done].nil?

      session['dashboard_'+@project.id.to_s] = @options
    end

    load_dashboard
  end

  def load_dashboard
    @dashboard = Dashboard.new(@project, :drag_allowed => User.current.allowed_to?(:edit_issues, @project))

    IssueStatus.find(:all, :order => 'position').each do |status|
      @dashboard << DashboardColumn.new("status-#{status.id}", status.name, :status => status.id) { |issue| issue.status == status } unless status.is_closed?
    end
    @dashboard << DashboardColumn.new('status-done', :label_column_done, :status => 'done') { |issue| issue.status.is_closed? && !@options[:hide_done] }

    case @options[:group]
    when 'trackers'
      @project.trackers.each do |tracker|
       @dashboard << DashboardGroup.new("tracker-#{tracker.id}", tracker.name, :tracker => tracker.id) { |issue| issue.tracker == tracker }
      end
    when 'priorities'
      IssuePriority.find(:all).reverse.each do |p|
        @dashboard << DashboardGroup.new("priority-#{p.position}", p.name, :priority => p.position) { |issue| issue.priority_id == p.id }
      end
    when 'assignee'
      @dashboard << DashboardGroup.new(:assigne_me, :my_issues, :assignee => User.current.id) { |issue| issue.assigned_to_id == User.current.id }
      @dashboard << DashboardGroup.new(:assigne_none, :unassigned, :assignee => 'none') { |issue| issue.assigned_to_id.nil? }
      @dashboard << DashboardGroup.new(:assigne_other, :others, :assignee => 'other') { |issue| !issue.assigned_to_id.nil? and issue.assigned_to_id != User.current.id }
    when 'categories'
      @project.issue_categories.each do |category|
        @dashboard << DashboardGroup.new("category-#{category.id}", category.name, :category => category.id) { |issue| issue.category_id == category.id }
      end
      @dashboard << DashboardGroup.new(:category_none, :unassigned, :category => 'none') { |issue| issue.category.nil? }
    when 'versions'
      @project.versions.each do |version|
        @dashboard << DashboardGroup.new("version-#{version.id}", version.name, :version => version.id) { |issue| issue.fixed_version_id == version.id }
      end
      @dashboard << DashboardGroup.new(:version_none, :unassigned, :version => 'none') { |issue| issue.fixed_version.nil? }
    end

    if @dashboard.groups.empty?
      @dashboard << DashboardGroup.new(:all, :all_issues)
    end
  end

  def load_issues
    @issues = @project.issues.to_a

    if not @options[:owner] == :all
      @issues = @issues.select { |i| i.assigned_to == User.current }
    end
    if not @options[:version].to_s == 'all'
      @issues = @issues.select { |i| i.fixed_version_id == @options[:version].to_i or (i.fixed_version_id.to_s == '' and @options[:version] == '0') }
    end
    if not @options[:tracker].to_s == 'all'
      @issues = @issues.select { |i| i.tracker_id == @options[:tracker].to_i }
    end
    if @options[:hide_done]
      @issues = @issues.select { |i| !i.status.is_closed? }
    end

    @issues = @issues.sort { |a,b| b.priority.position <=> a.priority.position }
  end

  def load_issue_resolutions(issue)
    @done_resolved = []
    resolution_field = issue_resolution_field(issue)
    return nil if resolution_field.nil?

    resolution_field.custom_field.possible_values.each do |v|
      @done_resolved << [v, v]
    end
    return @done_resolved
  end

  # TODO: Dirty method
  def issue_resolution_field(issue)
    issue.custom_field_values.each do |f|
      if f.custom_field.read_attribute(:name).downcase == 'resolution' and f.custom_field.field_format == 'list'
        return f
      end
    end
    return nil
  end

  def find_project
    @project = Project.find(params[:id])
    @edit_enabled = User.current.allowed_to?(:edit_issues, @project)

    @project_abbr = '#'
    @project.custom_field_values.each do |f|
      @project_abbr = f.to_s + '-' if f.to_s.length > 0 and f.custom_field.read_attribute(:name).downcase == 'abbreviation'
    end
  end

  def find_version
    version = @project.versions.open.find(:first, :order => 'effective_date ASC', :conditions => 'effective_date IS NOT NULL')
    return version.id unless version.nil?

    version = @project.versions.open.find(:first, :order => 'name ASC')
    return version.id unless version.nil?

    nil
  end
end
