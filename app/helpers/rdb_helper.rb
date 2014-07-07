module RdbHelper
  def html_import_tag(*sources)
    options = sources.last.is_a?(Hash) ? sources.pop : {}
    if plugin = options.delete(:plugin)
      sources = sources.map do |source|
        if plugin
          "/plugin_assets/#{plugin}/components/#{source}"
        else
          source
        end
      end
    end
    super sources, options
  end
end
