module Rdb::UI

  class MenuItem < ::Rdb::UI::Node
    def render_to(io)
      write_tag io, :li do |io|
        yield io if block_given?
      end
    end
  end
end
