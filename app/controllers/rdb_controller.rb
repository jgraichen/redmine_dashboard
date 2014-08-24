class RdbController < ::ApplicationController
  unloadable
  before_filter :board, only: [:show, :update, :destroy]
  respond_to :html

  def index
    if context
      sources = RdbSource.where context_id: context.id,
                                context_type: context.class

      if sources.any?
        redirect_to rdb_url sources.first.board
      else
        create
      end
    else

    end
  end

  def create
    ActiveRecord::Base.transaction do
      board = RdbBoard.create \
        name:   I18n.t('rdb.new.default_board_name', count: 0),
        engine: Rdb::Taskboard

      unless board.valid?
        board.name = I18n.t('rdb.new.default_board_name',
          count: RdbBoard.last.id + 1)
        board.save!
      end

      RdbSource.create! \
        context: context,
        board: board

      RdbBoardPermission.create! \
        rdb_board: board,
        principal: User.current,
        role: RdbBoardPermission::ADMIN

      redirect_to rdb_url board
    end
  end

  def show
  end

  def context
    params.key?(:id) ? board.sources.first.context : nil
  end

  private

  def board
    @board ||= RdbBoard.find(params[:id]).tap do |board|
      @engine = board.engine

      if board.sources.count == 1 && board.sources.first.context.is_a?(Project)
        @project = board.sources.first.context
        self.class.menu_item :rdb_project_dashboards
      end
    end
  end
end
