{Router} = require 'backbone'
classSet = require 'react/lib/cx'
counterpart = require 'counterpart'

core = require 'rui/core'
{div} = require 'rui/DOM'
GlobalEventBus = require './mixins/GlobalEventBus'

AppRouter = Router.extend
  routes:
    'dashboards/:id/configure': 'configure'
    'dashboards/:id': 'show'

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
    component = switch @state.current
      when 'show' then require './components/Board'
      when 'configure' then require './components/Configuration'
      else div

    cs = classSet
      'rdb-fullscreen': @state.fullscreen

    div id: 'redmine-dashboard', className: cs,
      @transferPropsTo component()

    # goTo: (event, url) =>
    #   if !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey
    #     event.preventDefault()
    #     @navigate url, trigger: true

module.exports =
  Router: AppRouter
  Component: AppComponent
