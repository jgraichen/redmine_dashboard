class DashboardController < ApplicationController
  unloadable

  before_filter :find_project
  
  def index
    load_issues
  end
  
  def update_issue
    issue = Issue.find(params[:issue]);
    status = IssueStatus.find_by_position(params[:status]);
    if !issue.nil? and !status.nil?
      issue.status = status
      issue.save
    end
    
    @message = "Issue #{issue.id} changed to #{status.name}, maybe."
    
    load_issues
    
    render '_dashboard', :layout => false
  rescue
    render_500
  end
  
  private
  def load_issues
    # issues ordered by priority desc
    @issues = @project.issues.sort { |a,b| b.priority.position <=> a.priority.position }
    @trackers = Tracker.find(:all)
    @statuses = IssueStatus.find(:all)[0..2]
  end
  
  def find_project
    @project = Project.find(params[:id])
  end
end
