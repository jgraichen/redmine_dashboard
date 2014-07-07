require 'nokogiri'
require 'uri'

module Rdb
  module Sprockets
    class ImportProcessor
      # ImportProcessor scans a file for html imports and adds them to the current
      # required assets.
      def initialize(context)
        @context = context
        @directory = File.dirname(context.pathname)
      end

      def process(data)
        doc = Nokogiri::HTML.fragment(data)
        require_assets(doc)
        remove_imports(doc)
        URI.unescape(doc.to_s.lstrip)
      end

      private

      def require_assets(doc)
        doc.css("link[rel='import']").each do |node|
          path = File.absolute_path(node.attribute('href'), @directory)
          @context.require_asset(path)
        end
      end

      def remove_imports(doc)
        doc.css("link[rel='import']").each do |node|
          node.remove
        end
      end
    end
  end
end
