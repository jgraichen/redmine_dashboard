{Router} = require 'exoskeleton'
classSet = require 'react/lib/cx'
counterpart = require 'counterpart'

core = require 'rui/core'
{div} = require 'rui/DOM'

Board = require 'rdb/Board'
BoardComponent = require 'rdb/BoardComponent'
GlobalEventBus = require 'rdb/GlobalEventBus'

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
    component: (root) -> root [ 'Loading...' ]
    board: @props.board

  onRoute: (route, data) ->
    switch route
      when 'index'
        @setState ->
          component: (root) ->
            root [ div ['INDEX'] ]
      when 'show', 'configure'
        @getBoard(data[0]).then (board) =>
          @setState
            component: (root) ->
              BoardComponent action: route, board: board, root: root

  getBoard: (id) ->
    if !@state.board || @state.board.get('id') != parseInt(id)
      board = new Board id: id
      @setState board: board

      board.fetch()
    else
      new Promise (resolve) => resolve @state.board

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
