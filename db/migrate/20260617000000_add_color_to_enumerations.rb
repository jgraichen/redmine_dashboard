# frozen_string_literal: true

class AddColorToEnumerations < ActiveRecord::Migration[6.1]
  def change
    add_column :enumerations, :dashboard_color, :string, null: true
  end
end
