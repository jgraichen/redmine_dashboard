class CreateRdbPermissions < ActiveRecord::Migration[4.2]
  def self.up
    create_table :rdb_permissions do |t|
      t.integer :dashboard_id,   null: false
      t.integer :principal_id,   null: false
      t.string  :principal_type, null: false
      t.string  :role,           null: false
      t.timestamps
    end
  end

  def self.down
    drop_table :rdb_permissions
  end
end
