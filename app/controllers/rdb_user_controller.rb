class RdbUserController < RdbController
  def context
    @user ||= find_current_user
  end
end
