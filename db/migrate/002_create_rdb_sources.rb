class CreateRdbSources < ActiveRecord::Migration
  def self.up
    create_table :rdb_sources do |t|
      t.integer :rdb_board_id, null: false
      t.integer :context_id,   null: false
      t.string  :context_type, null: false
      t.timestamps
    end
  end

  def self.down
    drop_table :rdb_sources
  end
end
