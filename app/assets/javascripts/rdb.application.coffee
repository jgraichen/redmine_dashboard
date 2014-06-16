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
      @show new Rdb.Views.BoardConfiguration Rdb.board

    showBoard: (id) =>
      @show new Rdb.Views.Board Rdb.board

    show: (view) =>
      @current?.$el.detach()
      @current = view

      $('#redmine-dashboard').html view.$el

    run: (data) =>
      Rdb.board = new Rdb.Board(data)

      Backbone.history.start pushState: true

      console.log "RUN APPLICATION", data

