class Rdb::BoardsController < ::ApplicationController
  def show
    render json: board
  end

  def update
    board.update params

    render json: board
  end

  private

  def board
    @board ||= RdbBoard.find(params[:id]).engine
  end
end
