class CreateRdbColumns < ActiveRecord::Migration[4.2]
  def self.up
    create_table :rdb_columns do |t|
      t.integer :dashboard_id, null: false
      t.string  :type,         null: false
      t.string  :name,         null: false
      t.string  :opts,         null: false
      t.timestamps
    end
  end

  def self.down
    drop_table :rdb_columns
  end
end
