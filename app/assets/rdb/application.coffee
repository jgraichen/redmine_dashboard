{Router} = require 'backbone'
classSet = require 'react/lib/cx'
counterpart = require 'counterpart'

core = require 'rui/core'
{div} = require 'rui/DOM'

Board = require './resources/Board'
BoardComponent = require './components/Board'
GlobalEventBus = require './mixins/GlobalEventBus'

AppRouter = Router.extend
  routes:
    'rdb/dashboards/:id/configure': 'configure'
    'rdb/dashboards/:id': 'show'
    'rdb/dashboards': 'index'

AppComponent = core.createComponent 'rdb.AppComponent',
  mixins: [GlobalEventBus],

  events:
    'route': 'onRoute'
    'rdb:fullscreen:toggle': 'toggleFullscreen'

  getInitialState: ->
    current: 'index'
    component: (root) -> root()

  onRoute: (route, data) ->
    switch route
      when 'index'
        @setState
          component: (root) ->
            root [ div ['INDEX'] ]
      when 'show', 'configure'
        @withBoard data[0], (board) =>
          @setState
            component: (root) ->
              BoardComponent action: route, board: board, root: root

  withBoard: (id, cb) ->
    if !@state.board || @state.board.get('id') != parseInt(id)
      board = new Board id: id
      board.fetch success: -> cb(board)

      @setState board: board
    else
      cb @state.board

  toggleFullscreen: ->
    fullscreen = !@state.fullscreen
    @setState fullscreen: fullscreen
    @trigger 'rdb:fullscreen:changed', fullscreen

  render: ->
    cs = classSet
      'rdb': true
      'rdb-fullscreen': @state.fullscreen

    root = (children) ->
      div id: 'content', className: cs, children

    @state.component root

module.exports =
  Router: AppRouter
  Component: AppComponent
