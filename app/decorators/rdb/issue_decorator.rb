module Rdb
  # The IssueDecorator decorates redmines Issue database model and
  # adds an as_json method as we need it.
  #
  class IssueDecorator < Draper::Decorator
    delegate_all

    def as_json(*)
      {
        id: id,
        subject: subject,
        description: description,
        name: name
      }
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
