module Rdb
  class BoardsController < BaseController
    before_action :check_read_permission, except: [:index, :update]
    before_action :check_write_permission, except: [:show, :index]

    def index
      render json: Dashboard.all
    end

    def show
      render json: board
    end

    def update
      board.update_board! params

      render json: board
    rescue ActiveRecord::RecordInvalid => e
      render status: 422, json: {errors: e.record.errors}
    end

    private

    def board
      @board ||= Dashboard.find Integer params[:id]
    end
  end
end
