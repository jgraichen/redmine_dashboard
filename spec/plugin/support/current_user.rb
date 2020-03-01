module CurrentUser
  def get(action, session: {}, **kwargs)
    session.merge! user_id: current_user.try(:id) if respond_to?(:current_user)
    super(action, session: session, **kwargs)
  end

  def patch(action, session: {}, **kwargs)
    session.merge! user_id: current_user.try(:id) if respond_to?(:current_user)
    super(action, session: session, **kwargs)
  end

  def post(action, session: {}, **kwargs)
    session.merge! user_id: current_user.try(:id) if respond_to?(:current_user)
    super(action, session: session, **kwargs)
  end

  def put(action, session: {}, **kwargs)
    session.merge! user_id: current_user.try(:id) if respond_to?(:current_user)
    super(action, session: session, **kwargs)
  end

  def delete(action, session: {}, **kwargs)
    session.merge! user_id: current_user.try(:id) if respond_to?(:current_user)
    super(action, session: session, **kwargs)
  end
end
