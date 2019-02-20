class CreateRdbDashboards < ActiveRecord::Migration[4.2]
  def self.up
    create_table :rdb_dashboards do |t|
      t.string  :name,         null: false
      t.string  :type,         null: false
      t.text    :preferences,  null: false
      t.timestamps
    end
  end

  def self.down
    drop_table :rdb_dashboards
  end
end
