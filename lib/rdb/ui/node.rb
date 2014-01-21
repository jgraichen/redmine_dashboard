module Rdb::UI

  class Node
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper

    def initialize
      yield self if block_given?
    end

    def tag(name, options = nil, open = false, escape = true)
      options[:class] = Array(options[:class]).map{|s| "rdb-#{s}"}.join(' ') if options[:class]
      super name, options, open, escape
    end

    def write_tag(io, type, content = nil, opts = {})
      opts, content = content, nil if Hash === content

      io << tag(type, opts, true)
      io << content if String === content
      yield io if block_given?
      io << "</#{type}>"
    end

    def render_to(io)
      raise NotImplementedError.new 'Subclass responsibility.'
    end

    def render
      io = StringIO.new
      render_to io
      io.string.html_safe
    end

    class << self
      def render(*args, &block)
        self.new(*args, &block).render
      end
    end
  end
end
