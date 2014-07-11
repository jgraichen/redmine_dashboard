class RdbSource < ActiveRecord::Base
  self.table_name = "#{table_name_prefix}rdb_sources#{table_name_suffix}"

  belongs_to :context, polymorphic: true
  belongs_to :board, class_name: 'RdbBoard', foreign_key: 'rdb_board_id'

  def issues
    context.issues
  end

  def categories
    context.issue_categories
  end

  def trackers
    context.trackers
  end
end
