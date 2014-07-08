t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Button = require 'rui/Button'
DropdownButton = require 'rui/DropdownButton'
GlobalEventBus = require '../mixins/GlobalEventBus'
FullscreenButton = require './FullscreenButton'
{h2, div, section, header, span} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.BoardComponent',
  mixins: [GlobalEventBus],

  events:
    'rdb:fullscreen:changed': 'setFullscreenState'

  getInitialState: ->
    fullscreen: false

  setFullscreenState: (state) ->
    @setState fullscreen: state

  render: ->
    div [
      header className: 'rdb-header', do =>
        if @state.fullscreen
          [
            div [ h2 @props.board.get 'name' ]
            div [ FullscreenButton fullscreen: @state.fullscreen ]
          ]
        else
          [
            div [
              DropdownButton
                large: true
                icon: 'grid-three-up'
                [
                  h2 "CONTENT"
                ]
              h2 @props.board.get 'name'
            ]
            div [
              Button
                large: true
                icon: 'cog'
                'href': @props.board.url.configure
                'title': t('rdb.header.actions.configure_board')
                'aria-label': t('rdb.header.actions.configure_board')
                onClick: (e) =>
                  util.handlePrimaryClick e, (e) =>
                    Rdb.events.trigger 'navigate', '/configure'
              FullscreenButton fullscreen: @state.fullscreen
            ]
          ]
      (section className: 'rdb-main', "X")
    ]

