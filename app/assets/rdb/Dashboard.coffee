t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Menu = require 'rui/Menu'
Button = require 'rui/Button'
Dropdown = require 'rui/Dropdown'
LayeredComponentMixin = require 'rui/LayeredComponentMixin'
{h2, div, section, header, span, a} = require 'rui/DOM'

Rdb = require 'rdb/index'
BoardMenu = require 'rdb/BoardMenu'
GlobalEventBus = require 'rdb/GlobalEventBus'

module.exports =
  mixins: [GlobalEventBus, LayeredComponentMixin],

  events:
    'rdb:fullscreen:changed': 'setFullscreenState'

  getInitialState: ->
    fullscreen: false
    open: false

  setFullscreenState: (state) ->
    @setState fullscreen: state

  renderLayer: ->
    Dropdown
      target: @refs['header'].getDOMNode(),
      visible: @state.open
      BoardMenu board: @props.board

  render: ->
    @props.root [
      div className: 'contextual', [
        do =>
          if !@state.fullscreen
            a
              href: @props.board.urls.configure,
              onClick: Rdb.nav(@props.board.urls.configure)
              [
                Icon glyph: 'pencil'
                t 'rdb.contextual.configure'
              ]
        a
          href: '#'
          onClick: (e) =>
            util.handlePrimaryClick e, (e) =>
              Rdb.events.trigger 'rdb:fullscreen:toggle'
          [
            Icon glyph: 'arrows-alt'
            t 'rdb.contextual.fullscreen'
          ]
      ]
      h2 ref: 'header', [
        do =>
          if @state.fullscreen
            @props.board.get 'name'
          else
            a
              id: 'rdb-menu'
              ref: 'menu'
              onClick: (e) =>
                util.handlePrimaryClick e, (e) =>
                  @setState open: !@state.open
              [
                Icon glyph: 'chevron-circle-down'
                @props.board.get 'name'
              ]
      ]

      section className: 'rdb-main', @renderBoard()
    ]
