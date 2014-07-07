module Rdb
  module Sprockets
    module Helpers
      module TagHelper
        class HTMLImportTag < ::ActionView::Helpers::AssetTagHelper::AssetIncludeTag
          def asset_name
            'components'
          end

          def extension
            'html'
          end

          def asset_tag(source, options)
            tag(:link, {'rel' => 'import', 'href' => path_to_asset(source, protocol: :request)}.merge(options))
          end
        end

        def html_path(source)
          asset_paths.compute_public_path(source, 'components', ext: 'html', protocol: :request)
        end
        alias_method :path_to_html, :html_path

        def html_import_tag(*sources)
          @html_import ||= HTMLImportTag.new(config, asset_paths)
          @html_import.include_tag(*sources)
        end
      end

      module ViewHelper
        def self.included(base)
          base.cattr_accessor :environment
        end

        def rdb_javascript_include_tag(*sources)
          options = sources.extract_options!.stringify_keys

          sources.map do |source|
            if (asset = RDB_ASSET_ENVIRONMENT["#{source}.js"])
              asset.to_a.map do |a|
                javascript_include_tag("/rdb/assets/#{a.logical_path}?body=1", options)
              end
            else
              javascript_include_tag(source, options)
            end
          end.flatten.uniq.join("\n").html_safe
        end

        def rdb_stylesheet_link_tag(*sources)
          options = sources.extract_options!.stringify_keys

          sources.map do |source|
            if (asset = RDB_ASSET_ENVIRONMENT["#{source}.css"])
              asset.to_a.map do |a|
                stylesheet_link_tag("/rdb/assets/#{a.logical_path}?body=1", options)
              end
            else
              stylesheet_link_tag(source, options)
            end
          end.flatten.uniq.join("\n").html_safe
        end

        def rdb_html_import_tag(*sources)
          options = sources.extract_options!.stringify_keys

          sources.map do |source|
            if (asset = RDB_ASSET_ENVIRONMENT["#{source}.html"])
              asset.to_a.map do |a|
                html_import_tag("/rdb/assets/#{a.logical_path}?body=1", options)
              end
            else
              html_import_tag(source, options)
            end
          end.flatten.uniq.join("\n").html_safe
        end
      end
    end
  end
end
