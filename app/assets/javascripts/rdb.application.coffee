#
#= require_self
#= require rdb.board
#= require_tree ./collections
#= require_tree ./resources
#= require_tree ./views
#
Rdb.ready ($, _, Backbone) ->
  Rdb.Collections = {}
  Rdb.Resources = {}
  Rdb.Views = {}

  class Rdb.Application extends Backbone.Router
    routes:
      'dashboards/:id/configure': 'configureBoard'
      'dashboards/:id': 'showBoard'

    configureBoard: (id) =>
      @show new Rdb.Views.BoardConfiguration board: Rdb.board

    showBoard: (id) =>
      # @show new Rdb.Views.Board Rdb.board

    show: (view) =>
      @current?.detach()
      @current = view

      Rdb.root.html view.$el

    run: (data) =>
      Rdb.board = new Rdb.Board(data)
      Rdb.root  = $ '#redmine-dashboard'

      Rdb.root.on 'click', '[data-navigate]', (event) ->
        href = $(event.currentTarget).attr('href')

        if !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey
          event.preventDefault()
          url = href.replace(/^\//,'').replace('\#\!\/','')
          Rdb.application.navigate url, { trigger: true }

      Backbone.history.start pushState: true
