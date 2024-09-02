# frozen_string_literal: true

class RdbTrackerFilter < RdbFilter
  def initialize
    super(:tracker)
  end

  def scope(scope)
    return scope if all?

    scope.where tracker_id: values
  end

  def all?
    values.count == board.trackers.count
  end

  def apply_to_child_issues?
    true
  end

  def default_values
    board.trackers.pluck(:id)
  end

  def update(params)
    return unless (tracker = params[:tracker])

    if tracker == 'all'
      self.values = board.trackers.pluck(:id)
      return
    end

    id = tracker.to_i
    return if board.trackers.where(id: id).empty?

    if params[:only]
      self.value = id
    elsif values.include? id
      values.delete id if values.count > 2
    else
      values << id
    end
  end

  def title
    return I18n.t(:rdb_filter_tracker_all) if all?
    return I18n.t(:rdb_filter_tracker_multiple) if values.count > 1

    board.trackers.find(value).name
  end

  def enabled?(id)
    return true if value == :all

    values.include? id
  end
end
