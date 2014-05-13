# =========================================================
# Redmine Dashboard UI - Dropdown

Rdb.ready ($) ->
  closeAll = ->
    $('.rdb-handle.rdb-active').removeClass('rdb-active')
    $('.rdb-dropdown.rdb-visible').removeClass('rdb-visible')

  $(document).on 'click', (e) ->
    link = $(e.target).closest('.rdb-handle[data-rdb-popup]')

    if link.isAny()
      e.preventDefault()
      container = null

      unless link.popupContainer?
        selector = link.data('rdb-popup')
        unless selector.length > 0
          return

        dropdown  = $ "##{selector}"
        container = null
        switch dropdown.size()
          when 0
            return console.warn "No popup container for selector `#{selector}`"
          when 1
            container = dropdown.first()
          else
            return console.warn "Invalid number of popup containers for selector `#{selector}`"

        link.popupContainer = container
      else
        container = link.popupContainer

      if link.hasClass('rdb-active')
        link.removeClass('rdb-active')
        container.removeClass('rdb-visible')
      else
        closeAll()
        link.addClass('rdb-active')

        offset = link.offset()

        position =
          left: offset.left
          top: offset.top + link.outerHeight()

        if offset.left + container.outerWidth() > $(window).width()
          position.left = offset.left - container.outerWidth() + link.outerWidth()

        if offset.top + container.outerHeight() > $(window).height()
          position.top = offset.top - container.outerHeight()

        container
          .css
            left: position.left + 'px'
            top: position.top + 'px'
          .addClass('rdb-visible')
        container.find('a').first().focus()

    else
      closeAll()

  $(document).on 'mouseover', (e) ->
    if $(e.target).closest('.rdb-dropdown').isAny()
      $(e.target).focus()

  Rdb.key.bind ['down', 'right'], (e) ->
    container = $ '.rdb-dropdown.rdb-visible'
    if container.size() == 1
      e.preventDefault()
      links = container.find 'a'
      links.each (index, el) ->
        $el = $ el
        if $el.is(':focus') && links[index+1]
          links[index+1].focus()
          return false

  Rdb.key.bind ['up', 'left'], (e) ->
    container = $ '.rdb-dropdown.rdb-visible'
    if container.size() == 1
      e.preventDefault()
      links = container.find 'a'
      links.each (index, el) ->
        $el = $ el
        if $el.is(':focus') && links[index-1]
          links[index-1].focus()
          return false

  Rdb.key.bind 'esc', (e) ->
    if $('.rdb-dropdown.rdb-visible').isAny()
      closeAll()
