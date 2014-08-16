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

  onRoute: (route, data) ->
    switch route
      when 'index'
        @setState
          component: div ['INDEX']
      when 'show', 'configure'
        @withBoard data[0], (board) =>
          @setState component: BoardComponent action: route, board: board

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
      'rdb-fullscreen': @state.fullscreen

    div id: 'redmine-dashboard', className: cs, @state.component

module.exports =
  Router: AppRouter
  Component: AppComponent
