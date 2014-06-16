module Rdb
  class Taskboard < Engine
    self.name = 'taskboard'.freeze

    def setup

    end

    def columns
      @columns ||= begin
        IssueStatus.where(is_closed: false).map do |status|
          Columns::Status.new(self, statuses: status, name: status.name)
        end + [Columns::Status.new(self, statuses: IssueStatus.where(is_closed: true), name: :done)]
      end
    end

    def groups

    end
  end

  Engine.engines << Taskboard
end
