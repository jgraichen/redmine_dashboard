# =========================================================
# Redmine Dashboard UI - Menu Script

Rdb.ready ($) ->
  lastMenu = null

  $.fn.rdbMenuOpen = ->
    menu = $(this).closest('.rdb-menu')
    if menu.isAny()
      menu.addClass 'rdb-menu-active'

      section = menu.find('section').first()
      if section.isAny()
        listitem = section.find('ul.rdb-menu-list li a').first()
        if listitem.isAny()
          listitem.focus()

  $.fn.rdbMenuClose = ->
    menu = $(this).closest('.rdb-menu')
    if menu.isAny()
      menu.removeClass 'rdb-menu-active'
      lastMenu = null

  $(document).on 'click', (e) ->
    link = $(e.target).closest 'a.rdb-menu-link'

    if link.isAny() && link.closest('.rdb-container').isEmpty()
      e.preventDefault()
      if (menu = link.closest('.rdb-menu')).isAny()
        if lastMenu
          lastMenu.removeClass 'rdb-menu-active'
        if menu.is lastMenu
          lastMenu = null
        else
          menu.rdbMenuOpen()
          lastMenu = menu

    if lastMenu && $(e.target).closest('.rdb-menu').isEmpty()
      lastMenu.rdbMenuClose()

  Mousetrap.bind 'esc', (e) ->
    lastMenu.rdbMenuClose() if lastMenu

  $(document).on 'mousemove', '.rdb-menu-list a', (e) ->
    $(e.target).focus()
