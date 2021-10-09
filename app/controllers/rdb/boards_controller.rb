# frozen_string_literal: true

class Rdb::BoardController < ApplicationController
  before_action :find_project, :authorize

  def index
    respond_with Rdb::Dashboard.where(project: @project)
  end

  def show
    board
  end

  private

  def board
    @board ||= Rdb::Dashboad.where(project: @project).find(params[:board_id])
  end
end
