module DashboardHelper

  def render_dashboard_menu(options, opts = {})
    content_tag :span, :class => 'dashboard-menu' do
      s = content_tag(:span, :class => 'dashboard-menu-container') do
        options.map do |list|
          sx = ''
          sx << content_tag(:ul) do
            list.map do |item|
              next unless item.is_a? Array

              content_tag :li do
                opts[:link].call item[0], item[1]
              end
            end.join("\n").html_safe
          end
          sx
        end.join("\n").html_safe
      end
      content_tag(:a, opts[:name].call, :href => '#', :class => 'dashboard-menu-link') + s.html_safe
    end
  end
end
