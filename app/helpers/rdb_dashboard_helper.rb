module RdbDashboardHelper

  def render_rdb_menu(id, title, options = {}, &container)
    options[:class] ||= ''
    options[:class] += ' rdb-menu-right' if options[:right]
    options[:class] += ' rdb-small' if options[:small]

    haml_tag :div, :class => "rdb-menu rdb-menu-#{id} #{options[:class]}" do
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
    options, items = items, nil if items.is_a?(Hash)
    haml_tag :div, :class => "rdb-list #{options[:async] ? 'rdb-async' : ''} #{options[:class]}" do
      haml_tag :h3, options[:title] if options[:title]
      haml_tag options[:list_tag] ? options[:list_tag] : :ul, :class => options[:list_class] do
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

  def render_rdb_menu_list_item(options = {}, &block)
    haml_tag :li, :class => options[:async] ? 'rdb-async' : '' do
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

  def rdb_update_path(issue, options = {})
    send(:"rdb_#{@board.id}_update_path", {
      :issue => issue.id,
      :lock_version => issue.lock_version
    }.merge(options))
  end

  def rdb_move_path(issue, options = {})
    send(:"rdb_#{@board.id}_move_path", {
      :issue => issue.id,
      :lock_version => issue.lock_version
    }.merge(options))
  end

  def rdb_filter_path(options = {})
    send(:"rdb_#{@board.id}_filter_path", options)
  end

  def rdb_board_path(options = {})
    send(:"rdb_#{@board.id}_path", options)
  end
end
