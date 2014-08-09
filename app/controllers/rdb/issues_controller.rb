# = Rdb::IssuesController
#
# This controller is part of the Rdb REST API.
#
# It provides access to issue resources.
#
class Rdb::IssuesController < ::ApplicationController

  # Return a list of issues. Additional parameters must be passed to the
  # board (engine). E.g. the Taskboard uses an additional column parameter to
  # fetch issues for each column.
  #
  def index
    issues = board.issues params
    render json: Rdb::CollectionDecorator.new(issues, IssueDecorator)
  end

  private

  def board
    @board ||= RdbBoard.find(params[:rdb_board_id]).engine
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
