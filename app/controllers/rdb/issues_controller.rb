class Rdb::IssuesController < ::Rdb::BaseController
  before_filter :check_read_permission

  def index
    issues = board.engine.issues params
    render json: Rdb::CollectionDecorator.new(issues, Rdb::IssueDecorator)
  end

  private

  def board
    @board ||= RdbBoard.find Integer params[:rdb_board_id]
  end
end
