# frozen_string_literal: true

module RedmineDashboard
  module Patch
    def self.apply!
      ::IssuePriority.include(EnumerationColor)
      ::EnumerationsController.prepend(EnumerationsControllerColor)
    end
  end
end
