require 'nokogiri'
require 'uri'

module Rdb
  module Sprockets
    # StylesheetProcessor scans a document for external stylesheet references and
    # inlines them into the current document.
    class StylesheetProcessor
      def initialize(context)
        @context = context
      end

      def process(data)
        doc = Nokogiri::HTML.fragment(data)
        inline_styles(doc)
        URI.unescape(doc.to_s)
      end

      private

      def inline_styles(doc)
        doc.css("link[rel='stylesheet']").each do |node|
          path    = @context.resolve node.attribute("href")
          content = @context.environment[path].to_s
          style   = create_style(doc, content)
          node.replace(style)
        end
      end

      def create_style(doc, content)
        node = Nokogiri::XML::Node.new("style", doc)
        node.content = content
        node
      end
    end
  end
end
