class RdbProjectController < RdbController
  before_filter :find_project, :authorize

  def context
    @project
  end
end
