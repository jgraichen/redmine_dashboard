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
        return
      end
      
      status = IssueStatus.find_by_id(params[:status])
      old_status = @issue.status
      old_done_ratio = @issue.done_ratio
      allowed_statuses = @issue.new_statuses_allowed_to(User.current)
      
      # check if user is allowed to change ticket status and ticket status
      # is not the same as before
      if (User.current.admin? or allowed_statuses.include?(status)) and status != old_status
        
        @issue.update_attribute(:status_id, status.id)
        @issue.update_attribute(:done_ratio, params[:done_ratio].to_i) unless params[:done_ratio].nil?
        
        # Update the journal containing all the changes to the issue.
        journal = @issue.init_journal(User.current, params[:notes] || nil)
        journal.details << JournalDetail.new(
                                :property => 'attr',
                                :prop_key => 'status_id',
                                :old_value => old_status.id,
                                :value => status.id )
                                
        if not params[:done_ratio].nil?
          journal.details << JournalDetail.new(
                                  :property => 'attr',
                                  :prop_key => 'done_ratio',
                                  :old_value => old_done_ratio,
                                  :value => @issue.done_ratio )
        end

        load_issue_resolutions(@issue)
        resolution_field = issue_resolution_field(@issue)
        if resolution_field.value != params[:resolution].to_s
          old_resolution = resolution_field.value
          resolution_field.value = params[:resolution].to_s
          resolution_field.save
          journal.details << JournalDetail.new(
                                  :property => 'cf',
                                  :prop_key => resolution_field.custom_field.id,
                                  :old_value => old_resolution,
                                  :value => resolution_field.value )
        end
        journal.save
      end
    end
    
    load_issues
    render '_dashboard', :layout => false if request.xhr?
  rescue
    @message = 'Error: ' + $!
    
    load_issues
    render '_dashboard', :layout => false
  end
  
private
  def setup
    # TODO: Filter überarbeiten
    if params[:reset]
	    session[filter_name(:view)] = nil
	    session[filter_name(:owner)] = nil
	    session[filter_name(:version)] = nil
	    session[filter_name(:tracker)] = nil
	    session[filter_name(:group)] = nil
    else
	    session[filter_name(:view)] = params[:view].to_sym    if !params[:view].nil? and !VIEW_MODES[params[:view].to_sym].nil?
	    session[filter_name(:owner)] = params[:owner].to_sym  if params[:owner] == 'all' or params[:owner] == 'me'
	    session[filter_name(:version)] = params[:version]     if !params[:version].nil?
	    session[filter_name(:tracker)] = params[:tracker]     if !params[:tracker].nil?
	    session[filter_name(:group)] = params[:group]         if !params[:group].nil?
    end
    
    @view = session[filter_name(:view)] || :card;
    @owner = session[filter_name(:owner)] || :me;
    @version = session[filter_name(:version)] || find_version || :all
    @tracker = session[filter_name(:tracker)] || 'all';
    @group = session[filter_name(:group)] || 'none';
    
    load_dashboard
  end
  
  def find_version
  	version = @project.versions.open.find(:first, :order => 'effective_date ASC', :conditions => 'effective_date > 0')
  	return version.id unless version.nil?
  	version = @project.versions.open.find(:first, :order => 'name ASC')
  	return version.id unless version.nil?
  	nil
  end
  
  def load_dashboard
    @dashboard = Dashboard.new(:drag_allowed => User.current.allowed_to?(:edit_issues, @project))
    
    IssueStatus.find(:all, :order => 'position').each do |status|
      @dashboard << DashboardColumn.new(status.name, 'status', status.id) { |issue| issue.status == status } unless status.is_closed?
    end
    @dashboard << DashboardColumn.new(l(:label_column_done), 'status', 'done') { |issue| issue.status.is_closed? }
    
    case @group
    when 'trackers'
      @project.trackers.each do |tracker|
       @dashboard << DashboardGroup.new(tracker.name, 'tracker', tracker.id) { |issue| issue.tracker == tracker }
      end
    when 'priorities'
      IssuePriority.find(:all).reverse.each do |p|
        @dashboard << DashboardGroup.new(p.name, 'priority', p.position) { |issue| issue.priority_id == p.id }
      end
    when 'assignee'
      @dashboard << DashboardGroup.new(l(:my_issues), 'assignee', User.current.id) { |issue| issue.assigned_to_id == User.current.id }
      @dashboard << DashboardGroup.new(l(:unassigned), 'assignee', 'none') { |issue| issue.assigned_to_id.nil? }
      @dashboard << DashboardGroup.new(l(:others), 'assignee', 'other') { |issue| !issue.assigned_to_id.nil? and issue.assigned_to_id != User.current.id }
    when 'categories'
      @project.issue_categories.each do |category|
        @dashboard << DashboardGroup.new(category.name, 'category', category.id) { |issue| issue.category_id == category.id }
      end
      @dashboard << DashboardGroup.new(l(:unassigned), 'category', 'none') { |issue| issue.category.nil? }
    when 'versions'
      @project.versions.each do |version|
        @dashboard << DashboardGroup.new(version.name, 'version', version.id) { |issue| issue.fixed_version_id == version.id }
      end
      @dashboard << DashboardGroup.new(l(:unassigned), 'version', 'none') { |issue| issue.fixed_version.nil? }
    end

    if @dashboard.groups.empty?
      @dashboard << DashboardGroup.new(l(:all_issues), 'all', 'all')
    end
  end

  def load_issues
    # issues ordered by priority desc
    @issues = @project.issues
    @issues = @issues.select { |i| i.assigned_to == User.current } if @owner == :me
    if @version != 'all'
      @issues = @issues.select { |i| i.fixed_version_id == @version.to_i or (i.fixed_version_id.to_s == '' and @version == '0') }
    end
    if @tracker != 'all'
      @issues = @issues.select { |i| i.tracker_id == @tracker.to_i }
    end
    @issues.sort! { |a,b| b.priority.position <=> a.priority.position }
    @priorities = IssuePriority.find(:all)
    
    versions = @project.versions.find(:all) || []
    versions = versions.uniq.sort
    @versions_done = versions.select { |version| !version.open? }
    @versions_open = versions.select { |version| version.open? && !version.effective_date.nil? }
    @versions_open_wodate = versions.select { |version| version.open? && version.effective_date.nil? }
    
    @filter_trackers = []
    @project.trackers.each do |t|
      @filter_trackers << [t.name, t.id.to_s]
    end
  end
  
  def load_issue_resolutions(issue)
    @done_resolved = []
    resolution_field = issue_resolution_field(issue)
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
  end
  
  def find_project
    @project = Project.find(params[:id])
    @edit_enabled = User.current.allowed_to?(:edit_issues, @project)
    
    @project_abbr = '#'
    @project.custom_field_values.each do |f|
      @project_abbr = f.to_s + '-' if f.to_s.length > 0 and f.custom_field.read_attribute(:name).downcase == 'abbreviation'
    end
  end
  
  def filter_name(name)
    return 'dashboard_filter_'+@project.id.to_s+'_'+name.to_s
  end
end
