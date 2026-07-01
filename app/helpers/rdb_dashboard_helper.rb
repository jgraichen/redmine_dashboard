# frozen_string_literal: true

module RdbDashboardHelper
  def rdb_menu(id, title, header: nil, **options, &container)
    menu_classes = class_names(
      options[:class],
      'rdb-menu',
      "rdb-menu-#{id}",
      'rdb-menu-right': options[:right],
      'rdb-small': options[:small],
    )

    link = link_to(title, '#', class: 'rdb-menu-link')

    if %i[h1 h2 h3 h4 h5].include?(header)
      link = content_tag(header, link)
    end

    tag.div(class: menu_classes) do
      concat link
      concat(
        tag.div(
          class: class_names('rdb-container', 'rdb-container-right': options[:right]),
        ) do
          tag.div(
            class: class_names('rdb-container-wrapper', 'rdb-icons': options[:icons]),
          ) do
            if options[:inlet]
              tag.div(class: 'rdb-container-inlet', &container)
            else
              yield
            end
          end
        end,
      )
    end
  end

  def rdb_menu_list( # rubocop:disable Metrics/ParameterLists
    items = nil,
    async: false,
    title: nil,
    list_tag: :ul,
    list_class: nil,
    **kwargs
  )
    list_classes = class_names(kwargs[:class], 'rdb-list', 'rdb-async': async)
    tag.div(class: list_classes) do
      concat tag.h3(title) if title.present?

      concat(
        content_tag(list_tag, class: list_class) do
          if items
            items.each do |item|
              concat(tag.li { yield item })
            end
          else
            yield
          end
        end,
      )
    end
  end

  def rdb_menu_list_item(classes: nil, async: nil, &block)
    tag.li(
      class: class_names(classes, 'rdb-async': async),
      &block
    )
  end

  def rdb_checkbox_link_to(*args, enabled: nil, show_disabled: nil, **kwargs)
    kwargs[:class] = class_names(
      kwargs[:class],
      'rdb-checkbox-link',
      'rdb-checkbox-link-enabled': enabled,
      'rdb-checkbox-link-disabled': !enabled && show_disabled,
    )

    link_to(*args, **kwargs)
  end

  # rubocop:disable Rails/HelperInstanceVariable
  def rdb_update_path(issue, **kwargs)
    send(
      :"rdb_#{@board.id}_update_path",
      issue: issue.id,
      lock_version: issue.lock_version,
      **kwargs,
    )
  end

  def rdb_move_path(issue, **kwargs)
    send(
      :"rdb_#{@board.id}_move_path",
      issue: issue.id,
      lock_version: issue.lock_version,
      **kwargs,
    )
  end

  def rdb_filter_path(**kwargs)
    send(:"rdb_#{@board.id}_filter_path", **kwargs)
  end

  def rdb_board_path(**kwargs)
    send(:"rdb_#{@board.id}_path", **kwargs)
  end
  # rubocop:enable Rails/HelperInstanceVariable
end
