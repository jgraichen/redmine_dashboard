# frozen_string_literal: true

class RdbTaskboard < RdbDashboard
  def init
    # Init filters
    add_filter RdbAssigneeFilter.new
    add_filter RdbVersionFilter.new if versions.any?
    add_filter RdbTrackerFilter.new
    add_filter RdbCategoryFilter.new if issue_categories.any?
  end

  def setup(params)
    super

    if %w[tracker priority assignee category version parent none project].include? params[:group]
      options[:group] = params[:group].to_sym
    end

    if params[:hide_done]
      options[:hide_done] = (params[:hide_done] == 'true')
    end

    if params[:change_assignee]
      options[:change_assignee] = (params[:change_assignee] == 'true')
    end

    if (id = params[:hide_column])
      options[:hide_columns] ||= []
      options[:hide_columns].include?(id) ? options[:hide_columns].delete(id) : (options[:hide_columns] << id)
    end
  end

  def statuses
    ids = WorkflowTransition
      .where(tracker_id: filters[:tracker].values)
      .distinct
      .pluck(:old_status_id, :new_status_id)
      .flatten
      .uniq

    IssueStatus.where(id: ids).sorted
  end

  def build
    # Init columns
    options[:hide_columns] ||= []

    done_statuses = statuses.select do |status|
      next true if status.is_closed?

      add_column RdbColumn.new(
        "s#{status.id}",
        status.name,
        status,
        hide: options[:hide_columns].include?("s#{status.id}"),
      )

      false
    end

    if done_statuses.count == 1
      status = done_statuses.first
      add_column RdbColumn.new(
        "s#{status.id}",
        status.name,
        status,
        compact: options[:hide_done],
        hide: options[:hide_columns].include?("s#{status.id}"),
      )
    elsif done_statuses.count > 0
      add_column RdbColumn.new(
        'sX',
        :rdb_column_done,
        done_statuses,
        compact: options[:hide_done],
        hide: options[:hide_columns].include?('sX'),
      )
    end

    # Init groups
    case options[:group]
      when :tracker
        trackers.each do |tracker|
          add_group RdbGroup.new(
            "tracker-#{tracker.id}",
            tracker.name,
            accept: proc {|issue| issue.tracker == tracker },
          )
        end

      when :priority
        IssuePriority.reorder(position: :desc).each do |p|
          add_group RdbGroup.new(
            "priority-#{p.position}",
            p.name,
            accept: proc {|issue| issue.priority_id == p.id },
          )
        end

      when :assignee
        add_group RdbGroup.new(
          :assigne_me,
          :rdb_filter_assignee_me,
          accept: proc {|issue| issue.assigned_to_id == User.current.id },
        )
        add_group RdbGroup.new(
          :assigne_none,
          :rdb_filter_assignee_none,
          accept: proc {|issue| issue.assigned_to_id.nil? },
        )
        assignees.sort_by(&:name).each do |principal|
          next if principal.id == User.current.id

          add_group RdbGroup.new(
            "assignee-#{id}",
            principal.name,
            accept: proc {|issue| !issue.assigned_to_id.nil? && issue.assigned_to_id == principal.id },
          )
        end

      when :category
        issue_categories.each do |category|
          add_group RdbGroup.new(
            "category-#{category.id}",
            category.name,
            accept: proc {|issue| issue.category_id == category.id },
          )
        end
        add_group RdbGroup.new(
          :category_none,
          :rdb_unassigned,
          accept: proc {|issue| issue.category.nil? },
        )

      when :version
        versions.each do |version|
          add_group RdbGroup.new(
            "version-#{version.id}",
            version.name,
            accept: proc {|issue| issue.fixed_version_id == version.id },
          )
        end
        add_group RdbGroup.new(
          :version_none,
          :rdb_unassigned,
          accept: proc {|issue| issue.fixed_version.nil? },
        )

      when :project
        projects.each do |project|
          add_group RdbGroup.new(
            "project-#{project.id}",
            project.name,
            accept: proc {|issue| issue.project_id == project.id },
          )
        end

      when :parent
        issues.where(id: issues.pluck(:parent_id).uniq).uniq.each do |issue|
          add_group RdbGroup.new(
            "issue-#{issue.id}",
            issue.subject,
            accept: proc {|sub_issue| sub_issue.parent_id == issue.id },
          )
        end
        add_group RdbGroup.new(
          'issue-others',
          :rdb_no_parent,
          accept: proc {|issue| issue.parent.nil? },
        )
    end

    add_group RdbGroup.new(:all, :rdb_all_issues) if groups.empty?
  end

  # -------------------------------------------------------
  # Helpers

  def issues_for(column)
    filter column.scope(issues)
  end

  def columns
    @columns ||= HashWithIndifferentAccess.new
  end

  def column_list
    @column_list ||= []
  end

  def add_column(column)
    column.board = self
    column_list << column
    columns[column.id.to_s] = column
  end

  def visible_columns
    column_list.select(&:visible?)
  end

  def drop_on(issue)
    if User.current.admin?
      return column_list.reject {|c| c.statuses.include? issue.status }.map(&:id).join(' ')
    end

    return false unless issue&.attributes_editable?(User.current)

    statuses = issue.new_statuses_allowed_to(User.current)
    statuses.delete issue.status
    column_list.select do |c|
      (statuses & c.statuses).any?
    end.reject {|c| c.statuses.include? issue.status }.map(&:id).uniq.join(' ')
  end
end
