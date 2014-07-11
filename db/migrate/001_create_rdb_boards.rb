class CreateRdbBoards < ActiveRecord::Migration
  def self.up
    create_table :rdb_boards do |t|
      t.string  :name,         null: false
      t.string  :engine,       null: false
      t.text    :preferences,  null: false
      t.timestamps
    end
  end

  def self.down
    drop_table :rdb_boards
  end
end
