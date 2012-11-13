class Taskboard < Dashboard
  attr_reader :version

  def init
    # Init columns
    IssueStatus.find(:all, :order => 'position').each do |status|
      self << DashboardColumn.new("status-#{status.id}", status.name, :status => status.id) { |issue| issue.status == status } unless status.is_closed?
    end
    self << DashboardColumn.new('status-done', :dashboard_label_column_done, :status => 'done') { |issue| issue.status.is_closed? && !options[:hide_done] }

    # Init rows (groups)
    case options[:group]
    when 'tracker'
      project.trackers.each do |tracker|
        self << DashboardGroup.new("tracker-#{tracker.id}", tracker.name, :tracker => tracker.id) { |issue| issue.tracker == tracker }
      end
    when 'priority'
      IssuePriority.find(:all).reverse.each do |p|
        self << DashboardGroup.new("priority-#{p.position}", p.name, :priority => p.position) { |issue| issue.priority_id == p.id }
      end
    when 'assignee'
      self << DashboardGroup.new(:assigne_me, :dashboard_my_issues, :assignee => User.current.id) { |issue| issue.assigned_to_id == User.current.id }
      self << DashboardGroup.new(:assigne_none, :dashboard_unassigned, :assignee => 'none') { |issue| issue.assigned_to_id.nil? }
      self << DashboardGroup.new(:assigne_other, :dashboard_others, :assignee => 'other') { |issue| !issue.assigned_to_id.nil? and issue.assigned_to_id != User.current.id }
    when 'category'
      project.issue_categories.each do |category|
        self << DashboardGroup.new("category-#{category.id}", category.name, :category => category.id) { |issue| issue.category_id == category.id }
      end
      self << DashboardGroup.new(:category_none, :dashboard_unassigned, :category => 'none') { |issue| issue.category.nil? }
    when 'version'
      project.versions.each do |version|
        self << DashboardGroup.new("version-#{version.id}", version.name, :version => version.id) { |issue| issue.fixed_version_id == version.id }
      end
      self << DashboardGroup.new(:version_none, :dashboard_unassigned, :version => 'none') { |issue| issue.fixed_version.nil? }
    end

    self << DashboardGroup.new(:all, :dashboard_all_issues) if groups.empty?
  end

  def version
    Version.find_by_id options[:version] if options[:version] and options[:version] != 'all'
  end

  def filter_issues
    if options[:assignee] == :me
      @issues = @issues.select { |i| i.assigned_to_id == User.current.id }
    elsif options[:assignee].is_a? Fixnum
      @issues = @issues.select { |i| i.assigned_to_id == options[:assignee] }
    end

    if options[:version]
      @issues = @issues.select { |i| i.fixed_version_id == options[:version].to_i or (i.fixed_version_id.to_s == '' and options[:version] == '0') }
    end
    if options[:tracker]
      @issues = @issues.select { |i| i.tracker_id == options[:tracker].to_i }
    end
    if options[:hide_done]
      @issues = @issues.select { |i| !i.status.is_closed? }
    end

    @issues = @issues.sort { |a,b| b.priority.position <=> a.priority.position }
  end
end
