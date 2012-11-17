class RdbDashboardController < ApplicationController
  unloadable
  menu_item :dashboard
  before_filter :find_project, :authorize

  def index
    @board = self.board

    return redirect_to(rdb_taskboard_path) if params[:controller] == 'rdb_dashboard'
    return render_404 unless @board

    @board.setup *find_options

    if params[:update]
      update params[:update]
    end

    self.session_options = @board.session_options
  end

  def board; end

  def configure

  end

  def update(params)
  end

private
  def find_options
    [ session_options, params ]
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
