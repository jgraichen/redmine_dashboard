# frozen_string_literal: true

class CreateRdbColumns < ActiveRecord::Migration[5.2]
  def change
    create_table :rdb_columns do |t|
      t.string :type, null: false
      t.string :title, null: false
      t.integer :position, null: false
      t.integer :values, array: true, null: false
      t.references :board, null: false, index: true, foreign_key: {to_table: :rdb_boards}
      t.timestamps

      t.index %i[position board_id], unique: true
    end
  end
end
