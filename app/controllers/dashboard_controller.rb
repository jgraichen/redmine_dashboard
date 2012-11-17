class DashboardController < ApplicationController
  unloadable
  before_filter :find_project, :authorize

  def taskboard
    @board = Taskboard.new @project
    @board.setup *find_options
    self.session_options = @board.session_options
    render 'index'
  end

  def planboard
    @board = Planboard.new @project
    @board.setup *find_options
    self.session_options = @board.session_options
    render 'index'
  end

  def configure

  end

private
  def find_options
    params[:reset] ? [ {}, {} ] : [ session_options, params ]
  end

  def find_project
    @project = Project.find(params[:id])
  end

  def update_board(board)
    self.options = board.update(params)
  end

  def session_options
    session["dashboard_#{@project.id}_#{User.current.id}_#{@board.id}"] ||= {}
  end

  def session_options=(options)
    session["dashboard_#{@project.id}_#{User.current.id}_#{@board.id}"] = options
  end

  def session_id
    "dashboard_#{@project.id}_#{User.current.id}"
  end
end
