module Rdb
  class Column < ActiveRecord::Base
    self.table_name = "#{table_name_prefix}rdb_columns#{table_name_suffix}"

    serialize :opts
    belongs_to :dashboard, class_name: 'Rdb::Dashboard'
    validates :dashboard, :name, presence: true

    after_initialize do
      self.opts = {} unless read_attribute(:opts).is_a?(Hash)
    end

    def scope(issues)
      raise NotImplementedError
    end

    def issues
      scope dashboard.issues.includes(:priority).order('enumerations.position DESC')
    end

    def opts
      opts = read_attribute :opts
      opts = {} unless opts.is_a?(Hash)
      opts
    end

    def column_id
      id
    end

    def as_json(*)
      {id: column_id, name: name}
    end
  end

  class Column::Status < Column
    def scope(issues)
      issues.where(status_id: statuses)
    end

    def statuses
      IssueStatus.where id: opts.fetch(:statuses, [])
    end

    def statuses=(statuses)
      statuses = Array statuses
      statuses.map! do |status|
        if status.is_a?(IssueStatus)
          status.id
        else
          if IssueStatus.where(id: status.to_i).any?
            status.to_i
          else
            raise ArgumentError.new 'IssueStatus with id #{status.to_i} not found.'
          end
        end
      end

      self.opts = opts.merge(statuses: statuses)
    end
  end
end
