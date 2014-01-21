module Rdb::UI

  class MenuSection < ::Rdb::UI::Node
    attr_reader :title

    def initialize(title = nil, &block)
      @title = title
      super &block
    end

    def render_to(io)
      write_tag io, :section do |io|
        write_tag io, :header, self.title if title
        yield io if block_given?
      end
    end
  end
end
