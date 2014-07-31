module Rdb
  class Taskboard < Engine
    def setup

    end

    def columns
      @columns ||= begin
        IssueStatus.where(is_closed: false).map do |status|
          Columns::Status.new(self, id: status.id, statuses: status, name: status.name)
        end + [Columns::Status.new(self, id: 0, statuses: IssueStatus.where(is_closed: true), name: :done)]
      end
    end

    def groups

    end

    def as_json(*)
      super.merge \
        columns: columns.map(&:as_json)
    end
  end

  Engine.engines << Taskboard
end
