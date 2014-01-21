module Rdb::UI

  class MenuItemLink < ::Rdb::UI::Node
    def initialize(name, url)
      @name = name
      @url  = url
    end

    def render_to(io)
      io.write link_to(@name, @url)
    end
  end
end
