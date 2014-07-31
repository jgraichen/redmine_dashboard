class RdbUserDashboardsController < RdbDashboardsController
  def context
    @user ||= find_current_user
  end
end
