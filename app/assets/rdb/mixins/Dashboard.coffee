t = require 'counterpart'

core = require 'rui/core'
Icon = require 'rui/Icon'
Menu = require 'rui/Menu'
Button = require 'rui/Button'
DropdownButton = require 'rui/DropdownButton'
{h2, div, section, header, span} = require 'rui/DOM'

BoardMenu = require '../components/BoardMenu'
GlobalEventBus = require './GlobalEventBus'
FullscreenButton = require '../components/FullscreenButton'

module.exports =
  mixins: [GlobalEventBus],

  events:
    'rdb:fullscreen:changed': 'setFullscreenState'

  getInitialState: ->
    fullscreen: false

  setFullscreenState: (state) ->
    @setState fullscreen: state

  render: ->
    div id: 'rdb-board', [
      header className: 'rdb-header', [
        div [
          do =>
            if !@state.fullscreen
              DropdownButton
                large: true
                id: 'rdb-menu'
                label: [ Icon glyph: 'power-off', large: true ]
                target: '#rdb-board > header'
                BoardMenu board: @props.board
          h2 @props.board.get 'name'
        ]
        div [
          FullscreenButton id: 'rdb-fullscreen', fullscreen: @state.fullscreen
        ]
      ]
      section className: 'rdb-main', @renderBoard()
    ]
