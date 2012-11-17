class RdbTaskboardController < RdbDashboardController
  menu_item :dashboard

  def board
    RdbTaskboard.new @project
  end

  def update(params)
    if not params[:lock_version]
      flash.now[:rdb_error] = I18n.t(:rdb_flash_missing_lock_version).html_safe
      return
    end

    if not issue  = @project.issues.find(params[:issue].to_i)
      flash.now[:rdb_error] = I18n.t(:rdb_flash_invalid_request).html_safe
      return
    end

    # Use current status as default
    status = issue.status

    # If column is given we have to find a matching new status
    if column = @board.find_column(params[:column])
      if not status = column.value
        flash.now[:rdb_error] = I18n.t(:rdb_flash_invalid_request).html_safe
        return
      end
    end

    allowed_statuses = issue.new_statuses_allowed_to(User.current)

    # check if user is allowed to change ticket status and ticket status
    # is not the same as before
    if (User.current.admin? or allowed_statuses.include?(status))
      issue.init_journal(User.current, params[:notes] || nil)

      issue.status_id      = status.id
      issue.lock_version   = params[:lock_version].to_i
      issue.done_ratio     = params[:done_ratio].to_i if params[:done_ratio]
      if (@board.options[:change_assignee] && issue.assigned_to_id != User.current.id) or params[:assigne_me]
        issue.assigned_to_id = User.current.id
      end
      if params[:unassigne_me] && issue.assigned_to_id == User.current.id
        issue.assigned_to_id = nil
      end

      issue.save
    else
      flash.now[:rdb_error] = I18n.t(:rdb_flash_illegal_workflow_action, :issue => issue.subject, :source => issue.status.name, :target => status.name).html_safe
    end
    false
  rescue ActiveRecord::StaleObjectError
    flash.now[:rdb_error] = I18n.t(:rdb_flash_stale_object, :issue => issue.subject).html_safe
    false
  end
end
