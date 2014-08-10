class RdbBoard < ActiveRecord::Base
  self.table_name = "#{table_name_prefix}rdb_boards#{table_name_suffix}"

  serialize :preferences
  has_many :sources, class_name: 'RdbSource'

  validates :name, uniqueness: true, presence: true

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

  after_initialize do
    unless preferences.is_a?(Hash)
      self.preferences = {}
    end
  end

  def issues
    if sources.any?
      sources.first.issues
    else
      Issue.where('FALSE')
    end
  end

  def categories
    if sources.any?
      sources.first.categories
    else
      Category.where('FALSE')
    end
  end

  def trackers
    if sources.any?
      sources.first.trackers
    else
      Tracker.where('FALSE')
    end
  end
end
