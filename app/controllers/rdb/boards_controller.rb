class Rdb::BoardsController < ::ApplicationController
  respond_to :json

  def show
    respond_with board
  end

  def update
    if (err = engine.update(params)) === true
      respond_with board
    else
      render :unprocessable_entity, params[:format] => err
    end
  end

  private

  def board
    @board ||= RdbBoard.find params[:id]
  end

  def engine
    board.engine
  end
end
