class RdbProjectBoardsController < RdbBoardsController
  before_filter :find_project, :authorize

  def context
    @project
  end
end
