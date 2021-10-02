# frozen_string_literal: true

module RdbDashboardHelper
  def render_rdb_menu(id, title, options = {}, &container)
    options[:class] ||= ''
    options[:class] += ' rdb-menu-right' if options[:right]
    options[:class] += ' rdb-small' if options[:small]

    slim_tag :div, class: "rdb-menu rdb-menu-#{id} #{options[:class]}" do
      if options[:anchor]
        link = options[:anchor].call.to_s.html_safe
      else
        link = link_to(title, '#', class: 'rdb-menu-link')
      end

      if options[:header] && %i[h1 h2 h3 h4 h5].include?(options[:header].to_sym)
        slim_tag(options[:header], link)
      else
        concat link
      end

      slim_tag :div, class: "rdb-container #{options[:right] ? 'rdb-container-right' : ''}" do
        slim_tag :div, class: "rdb-container-wrapper #{options[:icons] ? 'rdb-icons' : ''}" do
          if options[:inlet]
            slim_tag(:div, class: 'rdb-container-inlet', &container)
          else
            yield
          end
        end
      end
    end
  end

  def render_rdb_menu_list(items = nil, options = {})
    if items.is_a?(Hash)
      options = items
      items = nil
    end

    slim_tag :div, class: "rdb-list #{options[:async] ? 'rdb-async' : ''} #{options[:class]}" do
      slim_tag :h3, options[:title] if options[:title]
      slim_tag options[:list_tag] || :ul, class: options[:list_class] do
        if items
          items.each do |item|
            slim_tag :li do
              yield item
            end
          end
        else
          yield
        end
      end
    end
  end

  def render_rdb_menu_list_item(options = {}, &block)
    slim_tag(:li, class: options[:async] ? 'rdb-async' : '', &block)
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

    link_to(*args)
  end

  def rdb_update_path(issue, options = {})
    send(:"rdb_#{@board.id}_update_path", {
      issue: issue.id,
      lock_version: issue.lock_version
    }.merge(options),)
  end

  def rdb_move_path(issue, options = {})
    send(:"rdb_#{@board.id}_move_path", {
      issue: issue.id,
      lock_version: issue.lock_version
    }.merge(options),)
  end

  def rdb_filter_path(options = {})
    send(:"rdb_#{@board.id}_filter_path", options)
  end

  def rdb_board_path(options = {})
    send(:"rdb_#{@board.id}_path", options)
  end

  private

  def slim_tag(name, content = nil, **attrs)
    concat tag(name, attrs, true, true)
    concat(content) if content.present?
    yield if block_given?
    concat "</#{name}>".html_safe
  end
end
