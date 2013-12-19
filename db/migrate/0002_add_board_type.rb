class AddProject < ActiveRecord::Migration
  def self.up
    add_column :rdb_boards, :project_id, :integer, :null => true
  end

  def self.down
    remove_column :rdb_boards, :project_id
  end
end
