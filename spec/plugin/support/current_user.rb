module CurrentUser
  def get(action, params = {}, session = {}, flash = nil)
    session.merge! user_id: current_user.try(:id) if respond_to?(:current_user)
    super
  end

  def patch(action, params = {}, session = {}, flash = nil)
    session.merge! user_id: current_user.try(:id) if respond_to?(:current_user)
    super
  end
end
