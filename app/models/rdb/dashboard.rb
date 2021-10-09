# frozen_string_literal: true

class Rdb::Dashboard < ActiveRecord::Base
  self.table_name = "#{table_name_prefix}rdb_dashboards#{table_name_suffix}"

  belongs_to :project
  belongs_to :owner, class_name: 'User'
  belongs_to :query

  validates :name, :project, :owner, :query, presence: true

  def as_json(view:, **opts)
    {
      board: {
        id: id,
        url: view.rdb_dashboard_path(project, id, format: :json),
        name: name,
      },
      columns: columns.as_json(view: view, **opts),
    }
  end

  def issues
    query.base_scope
      .reorder(query.sort_clause)
      .reorder(query.sort_clause)
      .joins(query.joins_for_order_statement(query.sort_clause.join(',')))
  end

  def columns
    @columns ||= statuses.each_with_index.map do |status, index|
      Column.new(self, index, status.name, [status])
    end
  end

  def projects
    @projects ||= Project.where(project.project_condition(false))
  end

  def trackers
    @trackers ||= Tracker.joins(:projects).where(projects: {id: projects.select(:id)}).distinct.sorted
  end

  def statuses
    ids = WorkflowTransition
      .where(tracker: trackers.unscope(:order))
      .distinct
      .pluck(:old_status_id, :new_status_id)
      .flatten
      .uniq

    IssueStatus.where(id: ids).sorted
  end

  Column = Struct.new(:board, :id, :title, :statuses) do
    def as_json(**opts)
      {
        id: id,
        title: title,
        issues: issues_as_json(**opts),
      }
    end

    private

    def issues_as_json(view:, **)
      board.issues.where(status: statuses).map do |issue|
        {
          id: issue.id,
          url: view.issue_url(issue),
          subject: issue.subject,
          description: issue.description,
          tracker: issue.tracker.name,
          priority: issue.priority.name,
          assignee: issue.assigned_to ? issue.assigned_to.name : view.t('rdb.card.unassigned'),
          category: issue.category ? issue.category.name : 'No category',
          version: issue.fixed_version ? issue.fixed_version.name : 'No version',
        }
      end
    end
  end
end
