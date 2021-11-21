# frozen_string_literal: true

class Rdb::Board < ActiveRecord::Base
  self.table_name = "#{table_name_prefix}rdb_boards#{table_name_suffix}"

  belongs_to :project
  belongs_to :owner, class_name: 'User'
  belongs_to :query

  has_many :columns

  validates :title, :project, :owner, :query, presence: true

  def as_json(view:, **opts)
    {
      board: {
        id: id,
        url: view.rdb_board_path(project, id, format: :json),
        title: title,
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

  def create_default_columns!
    raise if columns.any?

    transaction do
      statuses.each_with_index do |status, index|
        ::Rdb::StatusColumn.create!(
          board: self,
          title: status.name,
          position: index,
          values: [status.id],
        )
      end
    end
  end
end
