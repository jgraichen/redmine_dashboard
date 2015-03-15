module Rdb
  class Taskboard < Dashboard
    attr_protected

    has_many :columns, class_name: 'Rdb::Column', foreign_key: 'dashboard_id'

    after_create do
      IssueStatus.rdb_open.each do |status|
        Column::Status.create! dashboard: self,
          name: status.name,
          statuses: status
      end

      Column::Status.create! dashboard: self,
        name: 'Done',
        statuses: IssueStatus.rdb_closed
    end

    def issues(params = {})
      if params.key?(:column)
        columns.find(params[:column]).scope super()
      else
        super()
      end
    end

    def as_json(*args)
      super.merge \
        columns: columns
    end
  end
end
