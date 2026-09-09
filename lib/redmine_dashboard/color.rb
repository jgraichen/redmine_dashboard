# frozen_string_literal: true

module RedmineDashboard
  module Color
    PALETTE = {
      gray: %w[gray-100 gray-300 gray-500 gray-700 gray-900],
      red: %w[red-100 red-300 red-500 red-700 red-900],
      orange: %w[orange-100 orange-300 orange-500 orange-700 orange-900],
      amber: %w[amber-100 amber-300 amber-500 amber-700 amber-900],
      yellow: %w[yellow-100 yellow-300 yellow-500 yellow-700 yellow-900],
      lime: %w[lime-100 lime-300 lime-500 lime-700 lime-900],
      green: %w[green-100 green-300 green-500 green-700 green-900],
      mint: %w[mint-100 mint-300 mint-500 mint-700 mint-900],
      cyan: %w[cyan-100 cyan-300 cyan-500 cyan-700 cyan-900],
      blue: %w[blue-100 blue-300 blue-500 blue-700 blue-900],
      indigo: %w[indigo-100 indigo-300 indigo-500 indigo-700 indigo-900],
      purple: %w[purple-100 purple-300 purple-500 purple-700 purple-900],
      pink: %w[pink-100 pink-300 pink-500 pink-700 pink-900]
    }.freeze

    ALL = PALETTE.values.flatten.freeze
  end
end
