module Rdb::UI

  class MenuList < MenuSection
    attr_reader :items, :name, :title

    def initialize(*args, &block)
      @items = []

      super *args, &block
    end

    def <<(node)
      items << node
    end

    def render_to(io)
      super do
        write_tag io, :ul, class: 'menu-list' do |io|
          items.each do |item|
            write_tag(io, :li){|io| item.render_to io}
          end
        end
      end
    end
  end
end
