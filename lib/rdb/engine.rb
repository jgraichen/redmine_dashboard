class Rdb::Engine
  # Database Board Record.
  #
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def issues(*)
    board.issues
  end

  def name
    board.name
  end

  def as_json(*args)
    {
      id: board.id,
      name: board.name,
      type: self.class.name.split('::').last.downcase,
      permissions: board.permissions.map do |p|
        ::Rdb::PermissionDecorator.new(p).as_json(*args)
      end
    }
  end

  def update(params)
    board.update_attributes! name: params[:name]
    board
  end

  class << self
    def lookup(name)
      if (engine = engines.detect { |klass| klass.name == name })
        engine
      else
        begin
          name.constantize
        rescue NameError
          nil
        end
      end
    end

    def lookup!(name)
      lookup(name).tap do |engine|
        raise NameError.new "No rdb board engine '#{name}' found.\nAvailable engines: #{engines.map(&:name).join(', ')}" unless engine
      end
    end

    def engines
      @engines ||= []
    end
  end

  # Require board engines otherwise they wont be picked up
  # in development mode.
  #
  require 'rdb/taskboard'
  require 'rdb/planboard'
end
