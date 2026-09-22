# frozen_string_literal: true

module RedmineDashboard
  module Patch
    module EnumerationColor
      extend ActiveSupport::Concern

      included do
        validates :dashboard_color, inclusion: {in: Color::ALL}, allow_blank: true
      end

      def dashboard_color_css_class
        if dashboard_color.present?
          "rdb-color-#{dashboard_color}"
        else
          'rdb-color-gray-300'
        end
      end
    end
  end
end
