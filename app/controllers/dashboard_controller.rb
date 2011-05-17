class DashboardController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :setup
  
  def index
    load_issues
  end
  
  def update
    if !params[:issue].nil? and @edit_enabled
      @issue = Issue.find(params[:issue]);
      if params[:status] == 'done'
        @done_statuses = []
        IssueStatus.find(:all).each do |s|
          @done_statuses << [s.name, s.id.to_s] if s.is_closed?
        end
        render '_dashboard_done', :layout => false
        return
      end
      
      status = IssueStatus.find_by_id(params[:status])
      old_status = @issue.status
      allowed_statuses = @issue.new_statuses_allowed_to(User.current)
      
      # check if user is allowed to change ticket status und ticket status
      # is not the same as before
      if allowed_statuses.include?(status) and status != old_status
        @issue.update_attribute(:status_id, status.id)
        # Update the journal containing all the changes to the issue.
        journal = @issue.init_journal(User.current)
        journal.details << JournalDetail.new(
                                :property => 'attr',
                                :prop_key => 'status_id',
                                :old_value => old_status.id,
                                :value => status.id )
        journal.save
      end
    end
    
    load_issues
    render '_dashboard', :layout => false
  rescue
    @message = 'Error: ' + $!
    
    load_issues
    render '_dashboard', :layout => false
  end
  
private
  def load_issues
    # issues ordered by priority desc
    @issues = @project.issues
    @issues = @issues.select { |i| i.assigned_to == User.current } if @owner == :me
    if @version != :all
      @issues = @issues.select { |i| i.fixed_version_id == @version.to_i or (!i.fixed_version_id? and @version == 0) }
    end
    @issues.sort! { |a,b| b.priority.position <=> a.priority.position }
    @trackers = Tracker.find(:all)
    @statuses = IssueStatus.find(:all).select { |s| !s.is_closed? }
    @statuses << IssueStatus.new({:name => 'Done', :is_closed => true})
    @filter_versions = []
    @project.versions.each do |v|
      @filter_versions << [v.name, v.id.to_s]
    end
    @priorities = IssuePriority.find(:all)
  end
  
  def find_project
    @project = Project.find(params[:id])
    @edit_enabled = User.current.allowed_to?(:edit_issues, @project)
    
    @project_abbr = '#'
    @project.custom_field_values.each do |f|
      @project_abbr = f.to_s + '-' if f.to_s.length > 0 and f.custom_field.read_attribute(:name).downcase == 'abbreviation'
    end
  end
  
  def setup
    # TODO: Filter überarbeiten
    session[:view] = (params[:view].nil? or params[:view] == 'card') ? :card : :list unless params[:view].nil?
    session[:owner] = (params[:owner].nil? or params[:owner] == 'all') ? :all : :me unless params[:owner].nil?
    session[:version] = (params[:version].nil? or params[:version] == 'all') ? :all : params[:version] unless params[:version].nil?
    
    @view = (session[:view].nil? or session[:view] == :card) ? :card : :list
    @owner = (session[:owner].nil? or session[:owner] == :all) ? :all : :me
    @version = (session[:version].nil? or session[:version] == :all) ? :all : session[:version]
    @done_status = IssueStatus.new({:name => 'Done', :is_closed => true})
  end
end
