class Rdb::BoardsController < ::ApplicationController
  def show
    render json: board
  end

  def update
    board.update params

    render json: board
  rescue ActiveRecord::RecordInvalid => e
    render status: 422, json: {errors: e.record.errors}
  end

  private

  def board
    @board ||= RdbBoard.find(params[:id]).engine
  end
end
