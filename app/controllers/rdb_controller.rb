
class RdbController < ::ApplicationController
  unloadable
  before_filter :board, :only => [:show, :update, :destroy]
  before_filter :init_context
  respond_to :html

  def index
    if boards.any?
      redirect_to rdb_url boards.first
    else
      create
    end
  end

  def show
    @engine = board.engine
  end

  def create
    board = RdbBoard.create! :context => context,
      :name => I18n.t('rdb.new.default_board_name'),
      :engine => Rdb::Taskboard
    redirect_to rdb_url board
  end

  def configure
  end

  def update

  end

  def destroy

  end

  private
  def board
    @board ||= RdbBoard.find(params[:id]).tap do |board|
      @project = board.context unless board.personal?
    end
  end

  def init_context
    case context
    when Project
      @project = context
      self.class.menu_item :rdb_project_dashboards
    when User
      @user = context
      self.class.menu_item :rdb_my_dashboards
    end
  end

  def context
    board.context
  end

  def boards
    context.rdb_boards
  end
end
