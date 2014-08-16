t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Menu = require 'rui/Menu'
Button = require 'rui/Button'
DropdownButton = require 'rui/DropdownButton'
GlobalEventBus = require './GlobalEventBus'
FullscreenButton = require '../components/FullscreenButton'
{h2, div, section, header, span, ul, li, a} = require 'rui/DOM'

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
                Menu [
                  a
                    href: @props.board.urls.configure
                    'title': t('rdb.menu.configure_board')
                    'aria-label': t('rdb.menu.configure_board')
                    onClick: (e) =>
                      util.handlePrimaryClick e, (e) =>
                        Rdb.events.trigger 'navigate', @props.board.urls.configure
                    [
                      Icon glyph: 'cog'
                      t('rdb.menu.configure_board')
                    ]
                  a
                    href: @props.board.urls.create
                    'title': t('rdb.menu.create_new_board')
                    'aria-label': t('rdb.menu.create_new_board')
                    [
                      Icon glyph: 'plus'
                      t('rdb.menu.create_new_board')
                    ]
                ]
          h2 @props.board.get 'name'
        ]
        div [
          FullscreenButton id: 'rdb-fullscreen', fullscreen: @state.fullscreen
        ]
      ]
      section className: 'rdb-main', @renderBoard()
    ]
