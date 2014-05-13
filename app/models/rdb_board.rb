#
class RdbBoard < ActiveRecord::Base
  self.table_name = "#{table_name_prefix}rdb_boards#{table_name_suffix}"

  serialize :preferences, Hash

  belongs_to :context, polymorphic: true

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
    if engine.respond_to?(:name)
      write_attribute :engine, engine.name.to_s
    else
      write_attribute :engine, engine.to_s
    end
  end

  def issues
    context.issues
  end

  def categories
    if context.is_a? Project
      context.issue_categories
    else
      []
    end
  end

  def tracker
    if context.is_a? Project
      context.trackers
    else
      []
    end
  end
end
