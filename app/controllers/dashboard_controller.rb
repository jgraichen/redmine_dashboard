class DashboardController < ApplicationController
  unloadable

  before_filter :find_project
  
  def index
    # issues ordered by priority desc
    @issues = @project.issues.sort { |a,b| b.priority.position <=> a.priority.position }
    @trackers = Tracker.find(:all)
    @statuses = IssueStatus.find(:all)[0..2]
  end
  
  def update_issue
    # issues ordered by priority desc
    @issues = @project.issues.sort { |a,b| b.priority.position <=> a.priority.position }
    @trackers = Tracker.find(:all)
    @statuses = IssueStatus.find(:all)[0..2]
    
    render '_dashboard', :layout => false
  end
  
  private
  def find_project
    @project = Project.find(params[:id])
  end
end
