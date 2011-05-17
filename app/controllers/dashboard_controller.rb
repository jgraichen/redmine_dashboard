class DashboardController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :setup
  
  def index
    load_issues
  end
  
  def update
    if !params[:issue].nil?
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
#  rescue
    #@message = 'Error: ' + $!
#    
    #load_issues
    #render '_dashboard', :layout => false
  end
  
private
  def load_issues
    # issues ordered by priority desc
    @issues = @project.issues
    @issues = @issues.select { |i| i.assigned_to == User.current } if @owner == :me
    @issues.sort! { |a,b| b.priority.position <=> a.priority.position }
    @trackers = Tracker.find(:all)
    @statuses = IssueStatus.find(:all).select { |s| !s.is_closed? }
    @statuses << IssueStatus.new({:name => 'Done', :is_closed => true})
    @priorities = IssuePriority.find(:all)
  end
  
  def find_project
    @project = Project.find(params[:id])
  end
  
  def setup
    session[:view] = (params[:view].nil? or params[:view] == 'card') ? :card : :list unless params[:view].nil?
    session[:owner] = (params[:owner].nil? or params[:owner] == 'all') ? :all : :me unless params[:owner].nil?
    
    @view = (session[:view].nil? or session[:view] == :card) ? :card : :list
    @owner = (session[:owner].nil? or session[:owner] == :all) ? :all : :me
    @done_status = IssueStatus.new({:name => 'Done', :is_closed => true})
  end
end
