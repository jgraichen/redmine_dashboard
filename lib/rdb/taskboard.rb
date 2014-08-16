class Rdb::Taskboard < Rdb::Engine
  def setup
  end

  def columns
    @columns ||= begin
      IssueStatus.all.map do |status|
        Columns::Status.new self,
          id: status.id,
          statuses: status,
          name: status.name
      end
    end
  end

  def groups
  end

  def issues(params = {})
    if params.key?(:column)
      id = Integer params[:column]

      column = columns.find{|c| c.id == id }
      column.scope(super)
    else
      super
    end
  end

  def as_json(*)
    super.merge \
      columns: columns.map(&:as_json)
  end

  Rdb::Engine.engines << self
end
