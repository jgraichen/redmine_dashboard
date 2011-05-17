class DashboardController < ApplicationController
  unloadable

  before_filter :find_project, :authorize, :setup
  
  def index
    load_issues
  end
  
  def update
    if !params[:issue].nil?
      issue = Issue.find(params[:issue]);
      status = IssueStatus.find_by_position(params[:status]);
      if !issue.nil? and !status.nil?
        issue.status = status
        issue.save
      end
    end
    
    load_issues
    render '_dashboard', :layout => false
  rescue
    render_500
  end
  
  private
  def load_issues
    # issues ordered by priority desc
    @issues = @project.issues
    @issues = @issues.select { |i| i.assigned_to == User.current } if @owner == :mine
    @issues.sort! { |a,b| b.priority.position <=> a.priority.position }
    @trackers = Tracker.find(:all)
    @statuses = IssueStatus.find(:all)[0..2]
  end
  
  def find_project
    @project = Project.find(params[:id])
  end
  
  def setup
    session[:view] = (params[:view].nil? or params[:view] == 'card') ? :card : :list unless params[:view].nil?
    session[:owner] = (params[:owner].nil? or params[:owner] == 'all') ? :all : :mine unless params[:owner].nil?
    @view = (session[:view].nil? or session[:view] == :card) ? :card : :list
    @owner = (session[:owner].nil? or session[:owner] == :all) ? :all : :mine
  end
end
