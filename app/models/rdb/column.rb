# frozen_string_literal: true

class Rdb::Column < ActiveRecord::Base
  self.table_name = "#{table_name_prefix}rdb_columns#{table_name_suffix}"

  scope :sorted, -> { order(:position) }

  belongs_to :board

  validates :title, :values, presence: true

  def as_json(**opts)
    {
      id: id,
      title: title,
      issues: issues_as_json(**opts),
    }
  end

  private

  def issues_as_json(view:, **)
    issues.map do |issue|
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
