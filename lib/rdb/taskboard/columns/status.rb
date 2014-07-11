module Rdb::Taskboard::Columns

  #
  #
  class Status < ::Rdb::Taskboard::Column
    attr_reader :statuses

    def initialize(engine, opts = {})
      super

      @statuses = Array(opts.delete(:statuses)) { raise ArgumentError.new 'statuses missing.' }
    end

    def scope(issues)
      issues.where :status_id => statuses.map(&:id)
    end
  end
end
