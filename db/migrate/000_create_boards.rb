class CreateBoards < ActiveRecord::Migration
  def self.up
    create_table :rdb_boards do |t|
      t.column :name, :string, :null => false
      t.column :preferences, :text, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :rdb_boards
  end
end
