# frozen_string_literal: true

class RdbDashboardController < ApplicationController
  menu_item :dashboard
  before_action :find_project, :authorize
  before_action :setup_board, except: :index
  before_action :find_issue, only: %i[move update]
  before_action :authorize_edit, only: %i[move update]
  after_action :save_board_options

  def index
    return redirect_to rdb_taskboard_url if params[:controller] == 'rdb_dashboard'

    setup_board
  end

  def filter
    render action: 'index'
  end

  def update
    render_404
  end

  def move
    render_404
  end

  private

  def board_type
    nil
  end

  def board
    board_type.new(@project, options_for(board_type.name), params)
  end

  def setup_board
    return render_404 unless (@board = board)

    @board.setup(params)
    @board.update(params)
    @board.build
    @board
  end

  def save_board_options
    save_options_for(@board.options, board_type.name) if @board
  end

  def authorize_edit
    return true if @issue&.attributes_editable?

    raise Unauthorized
  end

  def find_project
    @project = Project.find params[:id]
  end

  def find_issue
    flash_error :rdb_flash_missing_lock_version and return false unless params[:lock_version]

    @issue = Issue.find params[:issue]

    if @issue.lock_version != params[:lock_version].to_i
      flash_error :rdb_flash_stale_object, update: true, issue: @issue.subject
      return false
    end

    @issue.lock_version = params[:lock_version].to_i
    @issue
  end

  def flash_error(sym, **options)
    flash.now[:rdb_error] = I18n.t(sym, **options).html_safe
    Rails.logger.info "Render Rdb flash error: #{sym}"
    if options[:update]
      render('index', formats: :js)
    else
      render('error', formats: :js)
    end
  end

  def options_for(board)
    User.current.pref["rdb_#{@project.id}_#{board}"] ||
      session["dashboard_#{@project.id}_#{User.current.id}_#{board}"] || {}
  end

  def save_options_for(options, board)
    User.current.pref["rdb_#{@project.id}_#{board}"] = options
    User.current.pref.save
  end
end
