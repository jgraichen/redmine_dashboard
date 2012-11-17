class Dashboard::TrackerFilter < Dashboard::Filter

  def initialize
    super(:tracker)
  end

  def filter(issues)
    return issues if all?
    issues.select{|i| i.children.any? or values.include?(i.tracker_id) }
  end

  def all?
    values.count == board.project.trackers.count
  end

  def apply_to_child_issues?
    true
  end

  def default_values
    board.project.trackers.pluck(:id)
  end

  def update(params)
    return unless tracker = params[:tracker]

    if tracker == 'all'
      self.values = board.project.trackers.pluck(:id)
    else
      id = tracker.to_i
      if board.project.trackers.where(:id => id).any?
        if params[:only]
          self.value = id
        else
          if values.include? id
            self.values.delete id if values.count > 2
          else
            self.values << id
          end
        end
      end
    end
  end

  def title
    return I18n.t(:rdb_filter_tracker_all) if all?
    return I18n.t(:rdb_filter_tracker_multiple) if values.count > 1
    board.project.trackers.find(value).name
  end

  def accept_tracker?(id)
    return true if value == :all
    values.include? id
  end
end
