class RdbProjectController < RdbController
  before_action :find_project, :authorize

  def context
    @project
  end
end
