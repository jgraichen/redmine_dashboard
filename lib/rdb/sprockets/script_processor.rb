require 'nokogiri'
require 'uri'

module Rdb
  module Sprockets
    # ScriptProcessor scans a document for external script references and inlines
    # them into the current document.
    class ScriptProcessor
      def initialize(context)
        @context = context
      end

      def process(data)
        doc = Nokogiri::HTML.fragment(data)
        inline_scripts(doc)
        URI.unescape(doc.to_s)
      end

      private

      def inline_scripts(doc)
        doc.css('script[src]').each do |node|
          begin
            path = @context.resolve './' + node.attribute("src")
          rescue
            path = @context.resolve node.attribute("src")
          end

          content = @context.environment[path].to_s
          script  = create_script(doc, content)
          node.replace(script)
        end
      end

      def create_script(doc, content)
        node = Nokogiri::XML::Node.new('script', doc)
        node.content = content
        node
      end
    end
  end
end
