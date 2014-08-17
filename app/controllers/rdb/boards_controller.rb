class Rdb::BoardsController < ::ApplicationController
  before_filter :check_read_permission, except: [:index, :update]
  before_filter :check_write_permission, except: [:show, :index]

  def index
    render json: RdbBoard.all
  end

  def show
    render json: board
  end

  def update
    board.engine.update params

    render json: board
  rescue ActiveRecord::RecordInvalid => e
    render status: 422, json: {errors: e.record.errors}
  end

  private

  def board
    @board ||= RdbBoard.find Integer params[:id]
  end

  def check_read_permission
    unauthorized! unless board.readable_for? User.current
  end

  def check_write_permission
    unauthorized! unless board.writable_for? User.current
  end

  def unauthorized!
    head :unauthorized
  end
end
