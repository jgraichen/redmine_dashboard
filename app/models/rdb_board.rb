class RdbBoard < ActiveRecord::Base
  self.table_name = "#{table_name_prefix}rdb_boards#{table_name_suffix}"

  serialize :preferences, Hash

  belongs_to :context, :polymorphic => true

  def personal?
    context_type == 'Principal'
  end

  def engine_class
    Rdb::Engine.lookup! read_attribute :engine
  end

  def engine
    @engine = engine_class.new self
  end

  def engine=(engine)
    write_attribute(:engine, engine.responds_to?(:name) ? engine.name.to_s : engine.to_s)
  end

  def issues
    context.issues
  end
end
