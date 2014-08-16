{Router} = require 'backbone'
classSet = require 'react/lib/cx'
counterpart = require 'counterpart'

core = require 'rui/core'
{div} = require 'rui/DOM'

GlobalEventBus = require './mixins/GlobalEventBus'

AppRouter = Router.extend
  routes:
    'rdb/dashboards/:id/configure': 'configure'
    'rdb/dashboards/:id': 'show'

AppComponent = core.createComponent 'rdb.AppComponent',
  mixins: [GlobalEventBus],

  events:
    'route': 'onRoute'
    'rdb:fullscreen:toggle': 'toggleFullscreen'

  getInitialState: ->
    current: 'show'

  onRoute: (data) ->
    @setState current: data

  toggleFullscreen: ->
    fullscreen = !@state.fullscreen
    @setState fullscreen: fullscreen
    @trigger 'rdb:fullscreen:changed', fullscreen

  componentDidMount: ->
    @props.board.on 'change', =>
      @forceUpdate()
    , @

  componentWillUnmount: ->
    @props.board.off null, null, @

  render: ->
    boardComponent = switch @props.board.get("type")
      when 'taskboard'
        require('./components/Taskboard')
      else
        null

    component = switch @state.current
      when 'show'
        boardComponent board: @props.board
      when 'configure'
        boardComponent.Configuration board: @props.board

    cs = classSet
      'rdb-fullscreen': @state.fullscreen

    div id: 'redmine-dashboard', className: cs,
      @transferPropsTo component

module.exports =
  Router: AppRouter
  Component: AppComponent
