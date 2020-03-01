module Rdb
  class IssuesController < BaseController
    before_action :check_read_permission

    def index
      issues = board.issues params
      render json: IssueDecorator.new(issues)
    end

    private

    def board
      @board ||= Dashboard.find Integer params[:rdb_board_id]
    end
  end
end
