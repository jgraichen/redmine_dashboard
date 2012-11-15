class Taskboard < Dashboard

  def init
    # Init filters
    self << Dashboard::VersionFilter.new
    self << Dashboard::TrackerFilter.new
    self << Dashboard::AssigneeFilter.new
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
      self << Dashboard::Column.new(status.id, status.name,
        :accept => Proc.new {|issue| issue.status.id == status.id })
    end
    self << Dashboard::Column.new("done", :dashboard_label_column_done,
        :accept => Proc.new {|issue| issue.status.is_closed?},
        :hide => options[:hide_done])

    # Init groups
    if compact?
      case options[:group]
      when :tracker
        project.trackers.each do |tracker|
          self << Dashboard::Group.new("tracker-#{tracker.id}", tracker.name, :accept => Proc.new {|issue| issue.tracker == tracker })
        end
      when :priority
        IssuePriority.find(:all).reverse.each do |p|
          self << Dashboard::Group.new("priority-#{p.position}", p.name, :accept => Proc.new {|issue| issue.priority_id == p.id })
        end
      when :assignee
        self << Dashboard::Group.new(:assigne_me, :dashboard_my_issues, :accept => Proc.new {|issue| issue.assigned_to_id == User.current.id })
        self << Dashboard::Group.new(:assigne_none, :dashboard_unassigned, :accept => Proc.new {|issue| issue.assigned_to_id.nil? })
        self << Dashboard::Group.new(:assigne_other, :dashboard_others, :accept => Proc.new {|issue| !issue.assigned_to_id.nil? and issue.assigned_to_id != User.current.id })
      when :category
        project.issue_categories.each do |category|
          self << Dashboard::Group.new("category-#{category.id}", category.name, :accept => Proc.new {|issue| issue.category_id == category.id })
        end
        self << Dashboard::Group.new(:category_none, :dashboard_unassigned, :accept => Proc.new {|issue| issue.category.nil? })
      when :version
        project.versions.each do |version|
          self << Dashboard::Group.new("version-#{version.id}", version.name, :accept => Proc.new {|issue| issue.fixed_version_id == version.id })
        end
        self << Dashboard::Group.new(:version_none, :dashboard_unassigned, :accept => Proc.new {|issue| issue.fixed_version.nil? })
      end
    end

    self << Dashboard::Group.new(:all, :dashboard_all_issues) if groups.empty?
  end
end
