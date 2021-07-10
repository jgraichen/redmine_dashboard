# frozen_string_literal: true

class RdbAssigneeFilter < RdbFilter
  def initialize
    super :assignee
  end

  def scope(scope)
    case value
      when :me   then scope.where(assigned_to_id: User.current.id)
      when :none then scope.where(assigned_to_id: nil)
      when :all  then scope
      else scope.where(assigned_to_id: value)
    end
  end

  def apply_to_child_issues?
    true
  end

  def default_values
    [RdbDashboard.defaults[:assignee] || :me]
  end

  def update(params)
    return unless (assignee = params[:assignee])

    Rails.logger.warn "CHANGE ASSIGNE: #{assignee}"

    if (assignee == 'all') || (assignee == 'me') || (assignee == 'none')
      self.value = assignee.to_sym
    elsif board.assignees.where(id: assignee.to_i).any?
      self.value = assignee.to_i
    end

    Rails.logger.warn "CHANGE ASSIGNE: #{assignee} => #{values.inspect}"
  end

  def title
    case value
      when :all then I18n.t(:rdb_filter_assignee_all)
      when :me then I18n.t(:rdb_filter_assignee_me)
      when :none then I18n.t(:rdb_filter_assignee_none)
      else
        values.map {|id| board.assignees.find(id) }.map(&:name).join(', ')
    end
  end
end
