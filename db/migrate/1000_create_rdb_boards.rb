# frozen_string_literal: true

class CreateRdbBoards < ActiveRecord::Migration[5.2]
  def change
    create_table :rdb_boards do |t|
      t.string :title, null: false
      t.references :project, null: false, index: true, foreign_key: true
      t.references :owner, null: false, index: true, foreign_key: {to_table: :users}
      t.references :query, null: false, index: true, foreign_key: true
      t.text :preferences
      t.timestamps
    end
  end
end
