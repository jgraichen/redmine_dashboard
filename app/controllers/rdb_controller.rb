class RdbController < ::Rdb::BaseController
  unloadable
  before_filter :board, only: [:show, :update, :destroy]
  before_filter :check_read_permission, except: [:index]

  def index
    if context
      sources = Rdb::Source.where context_id: context.id,
                                  context_type: context.class

      if sources.any?
        redirect_to rdb_url sources.first.dashboard
      else
        create
      end
    else

    end
  end

  def create
    ActiveRecord::Base.transaction do
      board = Rdb::Taskboard.create name: I18n.t('rdb.new.default_board_name', count: 0)

      index = 2
      while !board.valid?
        board.name = I18n.t('rdb.new.default_board_name', count: index)
        index += 1
      end

      board.save!

      Rdb::Source.create! context: context, dashboard: board

      Rdb::Permission.create! \
        dashboard: board,
        principal: User.current,
        role: Rdb::Permission::ADMIN

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
    @board ||= Rdb::Dashboard.find(params[:id]).tap do |board|
      if board.sources.count == 1 && board.sources.first.context.is_a?(Project)
        @project = board.sources.first.context
        self.class.menu_item :rdb_project_dashboards
      end
    end
  end
end
