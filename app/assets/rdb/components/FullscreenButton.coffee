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
    @transferPropsTo Button
      large: true
      'title': t('rdb.menu.toggle_fullscreen')
      'aria-label': t('rdb.menu.toggle_fullscreen')
      onClick: (e) =>
        util.handlePrimaryClick e, (e) =>
          Rdb.events.trigger 'rdb:fullscreen:toggle'
      Icon
        large: true
        glyph: if @state.fullscreen then 'angle-double-down' else 'angle-double-up'
