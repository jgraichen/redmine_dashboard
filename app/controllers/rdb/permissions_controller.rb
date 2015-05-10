module Rdb
  class PermissionsController < BaseController
    before_filter :check_admin_permission

    def index
      render json: board.permissions
    end

    def show
      render json: permission
    end

    def search
      principals = PrincipalDecorator.new \
        Principal
          .where(Principal.arel_table[:id].not_in board.permissions.pluck(:principal_id))
          .where(Principal.arel_table[:login].not_eq(''))
          .like(params[:q])
          .limit(5)

      render json: principals
    end

    def update
      check_own_permission 'cannot_edit_own_permission' and return

      permission.update_attributes! role: params[:role].to_s.downcase
      render json: permission
    rescue ActiveRecord::RecordInvalid => err
      render status: 422, json: {errors: err.record.errors}
    end

    def create
      permission = Permission.create! \
        dashboard_id: params[:rdb_board_id],
        principal: lookup_principal(params[:principal]),
        role: params[:role]

      render json: permission
    rescue ActiveRecord::RecordInvalid => err
      render status: 422, json: {errors: err.record.errors}
    rescue ActiveRecord::RecordNotFound => err
      render status: 422, json: {errors: {principal_id: ['principal_not_found']}}
    end

    def destroy
      check_own_permission 'cannot_delete_own_permission' and return

      permission.destroy

      head status: :no_content
    end

    private

    def check_own_permission(error)
      if permission.principal == User.current && !User.current.admin?
        render status: 422, json: {errors: [error]}
        true
      else
        false
      end
    end

    def lookup_principal(principal)
      Principal.find_by! login: principal.to_s
    end

    def permission
      board.permissions.find params[:id]
    end

    def board
      @board ||= Dashboard.find Integer params[:rdb_board_id]
    end
  end
end
