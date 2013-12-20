class RdbTaskboard < RdbDashboard

  def init
    # Init filters
    self.add_filter RdbAssigneeFilter.new
    self.add_filter RdbVersionFilter.new if project.versions.any?
    self.add_filter RdbTrackerFilter.new
    self.add_filter RdbCategoryFilter.new if project.issue_categories.any?
  end

  def setup(params)
    super

    if ['tracker', 'priority', 'assignee', 'category', 'version', 'parent', 'none'].include? params[:group]
      options[:group] = params[:group].to_sym
    end

    if params[:hide_done]
      options[:hide_done] = (params[:hide_done] == 'true')
    end

    if params[:change_assignee]
      options[:change_assignee] = (params[:change_assignee] == 'true')
    end

    if id = params[:column]
      options[:hide_columns] ||= []
      options[:hide_columns].include?(id) ? options[:hide_columns].delete(id) : (options[:hide_columns] << id)
    end
  end

  def build
    # Init columns
    options[:hide_columns] ||= []
    done_statuses = IssueStatus.sorted.select do |status|
      next true if status.is_closed?
      self.add_column RdbColumn.new("s#{status.id}", status.name, status,
        :hide => options[:hide_columns].include?("s#{status.id}"))
      false
    end
    self.add_column RdbColumn.new("sX", :rdb_column_done, done_statuses,
      :compact => options[:hide_done], :hide => options[:hide_columns].include?("sX"))

    # Init groups
    case options[:group]
    when :tracker
      project.trackers.each do |tracker|
        self.add_group RdbGroup.new("tracker-#{tracker.id}", tracker.name, :accept => Proc.new {|issue| issue.tracker == tracker })
      end
    when :priority
      IssuePriority.find(:all).reverse.each do |p|
        self.add_group RdbGroup.new("priority-#{p.position}", p.name, :accept => Proc.new {|issue| issue.priority_id == p.id })
      end
    when :assignee
      self.add_group RdbGroup.new(:assigne_me, :rdb_filter_assignee_me, :accept => Proc.new {|issue| issue.assigned_to_id == User.current.id })
      self.add_group RdbGroup.new(:assigne_none, :rdb_filter_assignee_none, :accept => Proc.new {|issue| issue.assigned_to_id.nil? })
      self.add_group RdbGroup.new(:assigne_other, :rdb_filter_assignee_others, :accept => Proc.new {|issue| !issue.assigned_to_id.nil? and issue.assigned_to_id != User.current.id })
    when :category
      project.issue_categories.each do |category|
        self.add_group RdbGroup.new("category-#{category.id}", category.name, :accept => Proc.new {|issue| issue.category_id == category.id })
      end
      self.add_group RdbGroup.new(:category_none, :rdb_unassigned, :accept => Proc.new {|issue| issue.category.nil? })
    when :version
      project.versions.each do |version|
        self.add_group RdbGroup.new("version-#{version.id}", version.name, :accept => Proc.new {|issue| issue.fixed_version_id == version.id })
      end
      self.add_group RdbGroup.new(:version_none, :rdb_unassigned, :accept => Proc.new {|issue| issue.fixed_version.nil? })
    when :parent
      project.issues.joins(:children).uniq.all.each do |issue|
        self.add_group RdbGroup.new("issue-#{issue.id}", issue.subject, :accept => Proc.new { |sub_issue| sub_issue.parent_id == issue.id })
      end
      self.add_group RdbGroup.new("issue-others", :rdb_no_parent, :accept => Proc.new { |issue| issue.parent.nil? and issue.children.empty? })
    end

    self.add_group RdbGroup.new(:all, :rdb_all_issues) if groups.empty?
  end


  # -------------------------------------------------------
  # Helpers

  def issues_for(column)
    filter column.scope(project.issues)
  end

  def columns; @columns ||= HashWithIndifferentAccess.new end
  def column_list; @colum_list ||= [] end
  def add_column(column)
    column.board = self
    column_list << column
    columns[column.id.to_s] = column
  end

  def visible_columns; column_list.select{|c| c.visible?} end

  def drop_on(issue)
    if User.current.admin?
      return column_list.reject{|c| c.statuses.include? issue.status}.map(&:id).join(' ')
    end

    statuses = issue.new_statuses_allowed_to(User.current)
    statuses.delete issue.status
    column_list.select{|c| (statuses & c.statuses).any?}.reject{|c| c.statuses.include? issue.status}.map(&:id).uniq.join(' ')
  end
end
