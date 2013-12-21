class RdbUserBoardsController < RdbController
  def context
    @user ||= find_current_user
  end
end
