Rdb.ready ($) ->
  $(document).on 'click', '#rdb-js-fullscreen', ->
    root = $ '#redmine-dashboard'
    btn  = $ @

    root.toggleClass('rdb-fullscreen')

    if root.hasClass('rdb-fullscreen')
      btn.find('.fa')
        .removeClass('fa-angle-double-up')
        .addClass('fa-angle-double-down')
    else
      btn.find('.fa')
        .removeClass('fa-angle-double-down')
        .addClass('fa-angle-double-up')
