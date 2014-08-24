t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Menu = require 'rui/Menu'
Button = require 'rui/Button'
DropdownButton = require 'rui/DropdownButton'
{h2, div, section, header, span, a} = require 'rui/DOM'

Rdb = require 'rdb/index'
BoardMenu = require '../components/BoardMenu'
GlobalEventBus = require './GlobalEventBus'

module.exports =
  mixins: [GlobalEventBus],

  events:
    'rdb:fullscreen:changed': 'setFullscreenState'

  getInitialState: ->
    fullscreen: false

  setFullscreenState: (state) ->
    @setState fullscreen: state

  render: ->
    @props.root [
      div className: 'contextual', [
        a
          href: @props.board.urls.configure,
          onClick: Rdb.nav(@props.board.urls.configure)
          [
            Icon glyph: 'pencil'
            t 'rdb.contextual.configure'
          ]
        a
          onClick: (e) =>
            util.handlePrimaryClick e, (e) =>
              Rdb.events.trigger 'rdb:fullscreen:toggle'
          [
            Icon glyph: 'arrows-alt'
            t 'rdb.contextual.fullscreen'
          ]
      ]
      h2 [
        @props.board.get 'name'
      ]
      section className: 'rdb-main', @renderBoard()
    ]
    # div id: 'rdb-board', [
    #   header className: 'rdb-header', [
    #     div [
    #       do =>
    #         if !@state.fullscreen
    #           DropdownButton
    #             large: true
    #             id: 'rdb-menu'
    #             label: [ Icon glyph: 'power-off', large: true ]
    #             target: '#rdb-board > header'
    #             BoardMenu board: @props.board
    #       h2 @props.board.get 'name'
    #     ]
    #     div [
    #       FullscreenButton id: 'rdb-fullscreen', fullscreen: @state.fullscreen
    #     ]
    #   ]
    #   section className: 'rdb-main', @renderBoard()
    # ]
