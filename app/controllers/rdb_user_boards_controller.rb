class RdbUserBoardsController < RdbBoardsController
  def context
    @user ||= find_current_user
  end
end
