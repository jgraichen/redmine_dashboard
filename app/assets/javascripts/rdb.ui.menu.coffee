# =========================================================
# Redmine Dashboard UI - Menu Script

Rdb.ready ($) ->
  lastMenu = null
  menuIndecies = [1,2,3,4,5,6,7,8,9,0]

  $.fn.rdbMenuOpen = ->
    menu = $(this).closest('.rdb-menu')
    if menu.isAny()
      menu.addClass 'rdb-menu-active'

      section = menu.find('section').first()
      if section.isAny()
        listitem = section.find('ul.rdb-menu-list li a').first()
        if listitem.isAny()
          listitem.focus()

      Rdb.key.push 'rdb.ui.menu', menu

  $.fn.rdbMenuClose = ->
    menu = $(this).closest('.rdb-menu')
    if menu.isAny()
      menu.removeClass 'rdb-menu-active'
      lastMenu.closest('.rdb-menu').find('a.rdb-menu-link').focus()
      lastMenu = null
      Rdb.key.pop()

  $.fn.rdbMenuFocusNext = (e) ->
    e.preventDefault()
    menu = $(this).closest('.rdb-menu')
    if menu.isAny()
      links = menu.find('a')
      links.each (index, el) ->
        $el = $ el
        if $el.is(':focus') && links[index+1]
          links[index+1].focus()
          return false

  $.fn.rdbMenuFocusPrev = (e) ->
    e.preventDefault()
    menu = $(this).closest('.rdb-menu')
    if menu.isAny()
      links = menu.find('a')
      links.each (index, el) ->
        $el = $ el
        if $el.is(':focus') && links[index-1]
          links[index-1].focus()
          return false

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

  Rdb.key.define 'rdb.ui.menu', (bindings, menu) ->
    bindings.on 'up', (e) ->
      lastMenu?.rdbMenuFocusPrev e
    bindings.on 'down', (e) ->
      lastMenu?.rdbMenuFocusNext e
    bindings.on 'esc', (e) ->
      lastMenu?.rdbMenuClose e

    menu?.find('ul.rdb-menu-list li a').each (index) ->
      if index < menuIndecies.length
        num = menuIndecies[index]
        el = $ @
        if el.find('span.rdb-key').isAny()
          el.find('span.rdb-key').html("#{num}")
        else
          el.append("<span class=\"rdb-key\">#{num}</span>")

        bindings.on num, =>
          el.focus().click()
        , =>
          el.find('span.rdb-key').remove()

  $(document).on 'mousemove', '.rdb-menu-list a', (e) ->
    $(e.target).focus()
