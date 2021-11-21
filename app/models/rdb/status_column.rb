# frozen_string_literal: true

class Rdb::StatusColumn < Rdb::Column
  def issues
    board.issues.where(status: values)
  end
end
