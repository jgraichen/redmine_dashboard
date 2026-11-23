# frozen_string_literal: true

module RedmineDashboard
  module Patch
    module EnumerationsControllerColor
      extend ActiveSupport::Concern

      def enumeration_params
        dashboard_color = params.dig(:enumeration, :dashboard_color)
        if dashboard_color.present?
          super.merge(dashboard_color: dashboard_color)
        else
          super
        end
      end
    end
  end
end
