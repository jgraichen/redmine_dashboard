# frozen_string_literal: true

class RdbBoardsController < ApplicationController
  menu_item :dashboards
  before_action :find_project, :authorize

  def index
    @board = Rdb::Board.where(project: @project).first
    @board ||= create_default_board

    redirect_to rdb_board_path(@project, @board)
  end

  def show
    @board = Rdb::Board.find(params[:board_id])
  end

  def update
    @board = Rdb::Board.find(params[:board_id])
    issue = @board.issues.find(params[:issue])
    column = @board.columns.find(params[:column])

    # Get all status the user is allowed to assign and that are in the target column
    statuses = issue
      .new_statuses_allowed_to(User.current)
      .select {|status| column.values.include?(status.id) }

    if statuses.empty?
      render status: 422, json: {error: 'illegal workflow action'}
      return
    end

    issue.init_journal(User.current, nil)
    issue.status = statuses.first
    issue.save!

    render json: @board.as_json(view: view_context)
  end

  def find_current_user
    session.key?(:user_id) && User.active.find(session[:user_id])
  rescue StandardError
    nil
  end

  private

  def create_default_board
    ::ActiveRecord::Base.transaction do
      board_name = I18n.t(
        'rdb.dashboard.autocreate.board_name',
        project_name: @project.name,
      )

      query_name = I18n.t(
        'rdb.dashboard.autocreate.query_name',
        project_name: @project.name,
        board_name: board_name,
      )

      query = IssueQuery.create!(
        name: query_name,
        user: User.current,
        project: @project,
      )

      Rdb::Board.create!(
        title: board_name,
        owner: User.current,
        project: @project,
        query: query,
      ).tap(&:create_default_columns!)
    end
  end
end
