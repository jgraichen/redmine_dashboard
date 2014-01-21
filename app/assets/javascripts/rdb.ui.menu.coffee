# =========================================================
# Redmine Dashboard UI - Menu Script

jQuery ->
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
      lastMenu.removeClass 'rdb-menu-active'
      lastMenu = null


  $(document).on 'hover', '.rdb-menu-list > li > a', (e) ->
    $(this).focus()
