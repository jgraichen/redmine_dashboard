class RdbBoard < ActiveRecord::Base
  self.table_name = "#{table_name_prefix}rdb_boards#{table_name_suffix}"

  serialize :preferences, Hash
  has_many :sources, class_name: 'RdbSource'

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
    if rdb_board_sources.any?
      rdb_board_sources.first.issues
    else
      Issue.where('FALSE')
    end
  end

  def categories
    if rdb_board_sources.any?
      rdb_board_sources.first.categories
    else
      Category.where('FALSE')
    end
  end

  def tracker
    if rdb_board_sources.any?
      rdb_board_sources.first.tracker
    else
      Tracker.where('FALSE')
    end
  end

  def as_json(*)
    {
      id: id,
      name: name,
      engine: engine.class.name,
    }
  end
end
