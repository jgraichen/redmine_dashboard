class Rdb::BoardsController < ::ApplicationController
  respond_to :json

  def show
    respond_with board
  end

  private

  def board
    @board ||= RdbBoard.find params[:id]
  end
end
