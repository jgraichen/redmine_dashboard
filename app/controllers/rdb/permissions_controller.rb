class Rdb::PermissionsController < ::Rdb::BaseController
  before_filter :check_admin_permission

  def index
    render json: decorator.decorate_collection(board.permissions)
  end

  def show
    render json: decorator.decorate(permission)
  end

  def decorator
    Rdb::PermissionDecorator
  end

  def update
    if permission.principal == User.current
      render status: 422, json: {errors: [I18n.t('rdb.errors.cannot_edit_own_permission')]}
      return
    end

    permission.update_attributes! role: params[:role].to_s.downcase
    render json: decorator.decorate(permission)
  rescue ActiveRecord::RecordInvalid => err
    render status: 422, json: {errors: err.record.errors}
  end

  private

  def permission
    board.permissions.find params[:id]
  end

  def board
    @board ||= RdbBoard.find Integer params[:rdb_board_id]
  end
end
