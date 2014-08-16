{Router} = require 'backbone'
classSet = require 'react/lib/cx'
counterpart = require 'counterpart'

core = require 'rui/core'
{div} = require 'rui/DOM'

Board = require './resources/Board'
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
    board: @props.board

  onRoute: (route, data) ->
    switch route
      when 'index'
        @setState
          component: div ['INDEX']
      when 'show'
        @withBoard data[0], (board) =>
          @setState component: @boardComponent(board) board: board
      when 'configure'
        @withBoard data[0], (board) =>
          @setState component: @boardComponent(board).Configuration board: board

  withBoard: (id, cb) ->
    if !@state.board || @state.board.get('id') != id
      board = new Board id: id
      board.fetch success: -> cb(board)

      @setState board: board
    else
      cb @state.board

  boardComponent: (board) ->
    switch board.get("type")
      when 'taskboard'
        require('./components/Taskboard')
      else
        undefined

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
