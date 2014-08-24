class Rdb::IssuesController < ::Rdb::BaseController
  before_filter :check_read_permission

  def index
    issues = board.engine.issues params
    render json: Rdb::CollectionDecorator.new(issues, IssueDecorator)
  end

  private

  def board
    @board ||= RdbBoard.find Integer params[:rdb_board_id]
  end

  # The IssueDecorator decorates redmines Issue database model and
  # adds an as_json method as we need it.
  #
  class IssueDecorator < SimpleDelegator
    def as_json(*)
      {id: id, subject: subject, description: description, name: name}
    end

    def name
      if project.rdb_abbreviation.present?
        "#{project.rdb_abbreviation}-#{id}"
      else
        "##{id}"
      end
    end
  end
end
