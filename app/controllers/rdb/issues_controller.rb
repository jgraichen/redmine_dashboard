class Rdb::IssuesController < ::ApplicationController
  def index
    render json: ::Rdb::CollectionDecorator.new(board.issues, IssueDecorator)
  end

  private

  def board
    @board ||= RdbBoard.find(params[:rdb_board_id]).engine
  end

  class IssueDecorator < SimpleDelegator
    def as_json(*)
      {id: id, subject: subject, description: description}
    end
  end
end
