Exoskeleton = require 'exoskeleton'
assign = require 'object-assign'
React = require 'react'
$ = React.createElement

ActivityIndicator = require 'molecule/lib/activity-indicator'
Component = require 'molecule/lib/component'

Events = require './events'
Board = require './resources/board'

_fetchBoard = (id) ->
  board = new Board id: id
  board.fetch().then => board

class Application extends Component
  @include Events.Mixin

  events:
    route: 'route'
    toggleFullscreen: 'fullscreen:toggle'

  constructor: (props) ->
    super props

    assign @state,
      action: 'index'
      id: null,
      data: {}
      board: props.board
      fullscreen: props.fullscreen

  route: (route, data) =>
    state = action: route

    switch route
      when 'index'
        state.id = null
      when 'show'
        state.id = parseInt data[0]
      when 'configure'
        state.id   = parseInt data[0]
        state.data = pane: data[1]
      else
        state.action = '404'

    if state.id && (!@state.board? || @state.board.get('id') != state.id)
        state.board = null
        _fetchBoard(state.id).then (board) => @setState board: board

    @setState state

  toggleFullscreen: =>
    @setState fullscreen: !@state.fullscreen, =>
      Events.trigger 'fullscreen:toggled', @state.fullscreen

  prepare: (props) =>
    super props

    props.classList.push 'rdb'
    props.classList.push 'rdb-fullscreen' if @state.fullscreen

  renderComponent: (props) =>
    if @state.id && !@state.board
      $ 'div', id: 'content', className: 'rdb-loading', [ 'Loading...' ]

    else
      wrapper = do (cn = props.className) =>
        (content) => $ 'div', id: 'content', className: cn, content

      switch @state.action
        when 'index'
          wrapper $ 'div', null, 'INDEX: TODO'
        when 'show'
          $ @component(), wrapper: wrapper, board: @state.board
        when 'configure'
          $ @component().Configuration, wrapper: wrapper, board: @state.board
        else
          wrapper $ 'div', null, "Error: Unknown action: #{@state.action}"

  component: =>
    type = @state.board.get 'type'
    switch type
      when 'taskboard'
        require './taskboard'
      else
        undefined

class Application.Router extends Exoskeleton.Router
  routes:
    'rdb/dashboards/:id/configure': 'configure'
    'rdb/dashboards/:id': 'show'
    'rdb/dashboards': 'index'

  constructor: ->
    super arguments...

    @on 'all', -> Events.trigger arguments...

    Events.on 'navigate', (url, opts = {}) =>
      opts.trigger ?= true

      @navigate url, opts

module.exports = Application
