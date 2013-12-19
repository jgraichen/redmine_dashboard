
class RdbBoardsController < ::ApplicationController
  unloadable
  menu_item :dashboard
  before_filter :board, :only => [:show, :update, :destroy]

  def index
    if boards.any?
      redirect_to rdb_board_url boards.first
    else
      create
    end
  end

  def show
    engine_class = Rdb::Engine.lookup! board.engine
    @engine = engine_class.new self
  end

  def create
    board = RdbBoard.create! :context => context,
      :name => I18n.t('rdb.new.default_board_name'),
      :engine => Rdb::Taskboard
    redirect_to rdb_board_url board
  end

  def update

  end

  def destroy

  end

  private
  def board
    @board ||= RdbBoard.find params[:id]
  end

  def boards
    context.rdb_boards
  end
end
