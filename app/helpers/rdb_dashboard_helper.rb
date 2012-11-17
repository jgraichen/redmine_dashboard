module RdbDashboardHelper

  def render_rdb_menu(title, options = {}, &container)
    options[:class] ||= ''
    options[:class] += ' rdb-menu-right' if options[:right]

    haml_tag :div, :class => "rdb-menu #{options[:class]}" do
      if options[:anchor]
        link = options[:anchor].call.to_s.html_safe
      else
        link = link_to(title, '#', :class => 'rdb-menu-link')
      end

      if options[:header] and [:h1, :h2, :h3, :h4, :h5].include? options[:header].to_sym
        haml_concat content_tag(options[:header], link)
      else
        haml_concat link
      end

      haml_tag :div, :class => "rdb-container #{options[:right] ? 'rdb-container-right' : ''}" do
        haml_tag :div, :class => "rdb-container-wrapper #{options[:icons] ? 'rdb-icons' : ''}" do
          if options[:inlet]
            haml_tag :div, :class => 'rdb-container-inlet' do
              container.call
            end
          else
            container.call
          end
        end
      end
    end
  end

  def render_rdb_menu_list(items = nil, options = {}, &block)
    haml_tag :div, :class => 'rdb-list' do
      haml_tag :h3, options[:title] if options[:title]
      haml_tag :ul do
        if items
          items.each do |item|
            haml_tag :li do
              block.call item
            end
          end
        else
          block.call
        end
      end
    end
  end

  def render_rdb_menu_list_item(&block)
    haml_tag :li do
      block.call
    end
  end

  def rdb_checkbox_link_to(*args)
    options = args.extract_options!
    options[:class] ||= ''
    options[:class] += ' rdb-checkbox-link'
    options[:class] += ' rdb-checkbox-link-enabled' if options[:enabled]
    options[:class] += ' rdb-checkbox-link-disabled' if !options[:enabled] && options[:show_disabled]
    options[:class].strip!

    options.delete :enabled
    options.delete :show_disabled

    args << options

    link_to *args
  end
end
