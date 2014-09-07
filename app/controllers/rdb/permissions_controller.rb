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
    if permission.principal == User.current && !User.current.admin?
      render status: 422, json: {errors: [I18n.t(:'rdb.errors.cannot_edit_own_permission')]}
      return
    end

    permission.update_attributes! role: params[:role].to_s.downcase
    render json: decorator.decorate(permission)
  rescue ActiveRecord::RecordInvalid => err
    render status: 422, json: {errors: err.record.errors}
  end

  def create
    permission = RdbBoardPermission.create! \
      rdb_board_id: params[:rdb_board_id],
      principal: lookup_principal(params[:principal]),
      role: params[:role]

    render json: decorator.decorate(permission)
  rescue ActiveRecord::RecordInvalid => err
    render status: 422, json: {errors: err.record.errors}
  rescue ActiveRecord::RecordNotFound => err
    render status: 422, json: {errors: {principal_id: [I18n.t(:'rdb.errors.principal_not_found')]}}
  end

  def destroy
    permission.destroy

    head status: :no_content
  end

  private

  def lookup_principal(principal)
    case principal[:type].to_s.downcase
      when 'user'
        User.find principal[:id]
      else
        nil
    end
  end

  def permission
    board.permissions.find params[:id]
  end

  def board
    @board ||= RdbBoard.find Integer params[:rdb_board_id]
  end
end
