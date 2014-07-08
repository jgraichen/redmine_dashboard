t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Button = require 'rui/Button'
GlobalEventBus = require '../mixins/GlobalEventBus'

module.exports = core.createComponent 'rdb.FullscreenButton',
  mixins: [GlobalEventBus],

  events:
    'rdb:fullscreen:changed': 'setFullscreenState'

  getInitialState: ->
    fullscreen: @props.fullscreen

  setFullscreenState: (state) ->
    @setState fullscreen: state

  render: ->
    Button
      large: true
      icon: if @state.fullscreen then 'fullscreen-exit' else 'fullscreen-enter'
      'title': t('rdb.header.actions.toggle_fullscreen')
      'aria-label': t('rdb.header.actions.toggle_fullscreen')
      onClick: (e) =>
        util.handlePrimaryClick e, (e) =>
          Rdb.events.trigger 'rdb:fullscreen:toggle'
