class RdbBoard < ActiveRecord::Base
  self.table_name = "#{table_name_prefix}rdb_boards#{table_name_suffix}"

  serialize :preferences, Hash

  belongs_to :context, :polymorphic => true

  def personal?
    context_type == 'Principal'
  end

  def engine_class
    Rdb::Engines.lookup! engine
  end

  def issues
    context.issues
  end
end
