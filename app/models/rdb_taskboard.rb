class RdbTaskboard < RdbDashboard

  def init
    # Init filters
    self << RdbDashboard::VersionFilter.new
    self << RdbDashboard::TrackerFilter.new
    self << RdbDashboard::AssigneeFilter.new
  end

  def update(params)
    super

    if ['tracker', 'priority', 'assignee', 'category', 'version', 'none'].include? params[:group]
      options[:group] = params[:group].to_sym
    end

    if params[:hide_done]
      options[:hide_done] = (params[:hide_done] == 'true')
    end

    if params[:change_assignee]
      options[:change_assignee] = (params[:change_assignee] == 'true')
    end
  end

  def build
    # Init columns
    IssueStatus.sorted.each do |status|
      next if status.is_closed?
      self << RdbDashboard::Column.new(status.id, status.name,
        :scope => Proc.new {|scope| scope.where(:status_id => status.id)},
        :value => status)
    end
    ids = IssueStatus.where(:is_closed => true).pluck(:id)
    self << RdbDashboard::Column.new("done", :rdb_column_done,
        :scope => Proc.new {|scope| scope.where(:status_id => ids)},
        :hide => options[:hide_done])

    # Init groups
    if compact?
      case options[:group]
      when :tracker
        project.trackers.each do |tracker|
          self << RdbDashboard::Group.new("tracker-#{tracker.id}", tracker.name, :accept => Proc.new {|issue| issue.tracker == tracker })
        end
      when :priority
        IssuePriority.find(:all).reverse.each do |p|
          self << RdbDashboard::Group.new("priority-#{p.position}", p.name, :accept => Proc.new {|issue| issue.priority_id == p.id })
        end
      when :assignee
        self << RdbDashboard::Group.new(:assigne_me, :rdb_filter_assignee_me, :accept => Proc.new {|issue| issue.assigned_to_id == User.current.id })
        self << RdbDashboard::Group.new(:assigne_none, :rdb_filter_assignee_none, :accept => Proc.new {|issue| issue.assigned_to_id.nil? })
        self << RdbDashboard::Group.new(:assigne_other, :rdb_filter_assignee_others, :accept => Proc.new {|issue| !issue.assigned_to_id.nil? and issue.assigned_to_id != User.current.id })
      when :category
        project.issue_categories.each do |category|
          self << RdbDashboard::Group.new("category-#{category.id}", category.name, :accept => Proc.new {|issue| issue.category_id == category.id })
        end
        self << RdbDashboard::Group.new(:category_none, :rdb_unassigned, :accept => Proc.new {|issue| issue.category.nil? })
      when :version
        project.versions.each do |version|
          self << RdbDashboard::Group.new("version-#{version.id}", version.name, :accept => Proc.new {|issue| issue.fixed_version_id == version.id })
        end
        self << RdbDashboard::Group.new(:version_none, :rdb_unassigned, :accept => Proc.new {|issue| issue.fixed_version.nil? })
      end
    end

    self << RdbDashboard::Group.new(:all, :rdb_all_issues) if groups.empty?
  end
end
