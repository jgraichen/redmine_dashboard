module DashboardHelper

  def dashboard_menu(name, param, value, options, &block)
    title = nil
    content_tag :span, :class => 'dashboard-menu' do
      s = content_tag(:span, :class => 'dashboard-menu-container') do
        options.map do |list|
          sx = ''

          sx << content_tag(:h3, list.first[1]) if list.first[1].nil?
          sx << content_tag(:ul) do
            list.map do |item|
              next unless item.is_a? Array
              if not title
                if (item[1].to_s == value.to_s) or (item.size >= 3 and item[2] == value)
                  title = item[0]
                end
              end

              content_tag :li do
                block.call item[0], item[1]
              end
            end.join("\n").html_safe
          end
          sx
        end.join("\n").html_safe
      end
      content_tag(:a, title || name, :href => '#', :class => 'dashboard-menu-link') + s.html_safe
    end
  end
end
