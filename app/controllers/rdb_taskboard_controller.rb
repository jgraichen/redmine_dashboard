class RdbTaskboardController < RdbDashboardController
  menu_item :dashboard

  def board
    RdbTaskboard.new @project
  end

  def update(params)
    return unless issue  = @project.issues.find(params[:issue].to_i)
    return unless column = @board.find_column(params[:column])
    return unless group  = @board.find_group(params[:group])
    return unless status = column.value

    allowed_statuses = issue.new_statuses_allowed_to(User.current)

    # check if user is allowed to change ticket status and ticket status
    # is not the same as before
    if (User.current.admin? or allowed_statuses.include?(status)) and status.id != issue.status_id
      issue.init_journal(User.current, params[:notes] || nil)

      issue.status_id      = status.id
      issue.done_ratio     = params[:done_ratio].to_i if params[:done_ratio]
      issue.assigned_to_id = User.current.id if @board.options[:change_assignee] && issue.assigned_to_id != User.current.id

      issue.save
    else
      flash.now[:rdb_error] = I18n.t :rdb_flash_illegal_workflow_action
    end
    false
  end
end
