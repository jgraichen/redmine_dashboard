# =========================================================
# Redmine Dashboard UI - Tabs

Rdb.ready ($) ->
  $.fn.rdbTab = ->
    root = $(this)

    $(root).on 'click', '[data-tab]', (event) ->
      link = $ event.currentTarget
      pane = $ link.data('tab')

      if link.isAny() || pane.isAny()
        root.find('.rdb-tab.rdb-visible').removeClass('rdb-visible')
        root.find('[data-tab].rdb-active').removeClass('rdb-active')
        pane.addClass('rdb-visible')
        link.addClass('rdb-active')

        event.preventDefault()

    firstPane = root.find('.rdb-tab').first()
    if firstPane?
      firstPane.addClass('rdb-visible')
      $('[data-tab]').each ->
        link = $ this
        if firstPane.is(link.data('tab'))
          link.addClass('rdb-active')
