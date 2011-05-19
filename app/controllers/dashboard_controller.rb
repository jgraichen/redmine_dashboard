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
      allowed_statuses = @issue.new_statuses_allowed_to(User.current)
      
      # check if user is allowed to change ticket status und ticket status
      # is not the same as before
      if (User.current.admin? or allowed_statuses.include?(status)) and status != old_status
        @issue.update_attribute(:status_id, status.id)
        # Update the journal containing all the changes to the issue.
        journal = @issue.init_journal(User.current)
        journal.details << JournalDetail.new(
                                :property => 'attr',
                                :prop_key => 'status_id',
                                :old_value => old_status.id,
                                :value => status.id )

        load_issue_resolutions(@issue)
        resolution_field = issue_resolution_field(@issue)
        old_resolution = resolution_field.value
        resolution_field.value = params[:resolution].to_s
        resolution_field.save
        journal.details << JournalDetail.new(
                                :property => 'cf',
                                :prop_key => resolution_field.custom_field.id,
                                :old_value => old_resolution,
                                :value => resolution_field.value )
        journal.save
      end
    end
    
    load_issues
    render '_dashboard', :layout => false if request.xhr?
#  rescue
#    @message = 'Error: ' + $!
#    
#    load_issues
#    render '_dashboard', :layout => false
  end
  
  def update_dashboard_xhr
  end
  
private
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
    @trackers = Tracker.find(:all)
    @statuses = IssueStatus.find(:all).select { |s| !s.is_closed? }
    @statuses << IssueStatus.new({:name => l(:label_column_done), :is_closed => true})
    @priorities = IssuePriority.find(:all)
    
    @filter_versions = []
    @project.versions.each do |v|
      @filter_versions << [v.name, v.id.to_s]
    end
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
  
  def setup
    # TODO: Filter überarbeiten
    session[filter_name(:view)] = params[:view].to_sym    if !params[:view].nil? and !VIEW_MODES[params[:view].to_sym].nil?
    session[filter_name(:owner)] = params[:owner].to_sym  if params[:owner] == 'all' or params[:owner] == 'me'
    session[filter_name(:version)] = params[:version]     if !params[:version].nil?
    session[filter_name(:tracker)] = params[:tracker]     if !params[:tracker].nil?
    
    @view = session[filter_name(:view)] || :card;
    @owner = session[filter_name(:owner)] || :all;
    @version = session[filter_name(:version)] || 'all';
    @tracker = session[filter_name(:tracker)] || 'all';
  end
end
