module Rdb
  # The IssueDecorator decorates redmines Issue database model and
  # adds an as_json method as we need it.
  #
  class IssueDecorator < Decorator
    def as_json(*)
      {
        id: object.id,
        subject: object.subject,
        description: object.description,
        name: name
      }
    end

    def name
      if object.project.rdb_abbreviation.present?
        "#{object.project.rdb_abbreviation}-#{object.id}"
      else
        "##{object.id}"
      end
    end
  end
end
