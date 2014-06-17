# =========================================================
# Redmine Dashboard UI - Dropdown

Rdb.ready ($) ->
  closeAll = ->
    $('[data-rdb-popup].rdb-active').removeClass('rdb-active')
    $('.rdb-dropdown.rdb-visible').removeClass('rdb-visible')

  $(document).on 'click', (e) ->
    link = $(e.target).closest('[data-rdb-popup]')

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

        container
          .find('.rdb-dropdown-container')
          .css('max-height', 'inherit')

        offset = link.offset()

        position =
          left: offset.left
          top: offset.top + link.outerHeight()

        # Check left/right
        if offset.left + container.outerWidth() > $(window).width()
          position.left = offset.left - container.outerWidth() + link.outerWidth()

        # Padding that should always be at the top and bottom
        SPACE_PADDING = 25

        spaceAbove = offset.top - SPACE_PADDING
        spaceBelow = $(window).height() - offset.top - link.outerHeight() - SPACE_PADDING

        # Check if dialog is longer then screen space bellow button
        if spaceBelow < container.outerHeight()

          # Check if dialog is longer then screen space above
          if spaceAbove < container.outerHeight()
            spaceMissing = container.outerHeight() - spaceBelow - link.outerHeight()
            position.top = offset.top - Math.min(spaceMissing, spaceAbove)

            container
              .find('.rdb-dropdown-container')
              .css('max-height', "#{spaceAbove + spaceBelow + link.outerHeight()}px")

          else
            # We do have enough space above so move dropdown up
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
