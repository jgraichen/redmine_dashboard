t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Menu = require 'rui/Menu'
Button = require 'rui/Button'
DropdownButton = require 'rui/DropdownButton'
GlobalEventBus = require '../mixins/GlobalEventBus'
FullscreenButton = require './FullscreenButton'
{h2, div, section, header, span, ul, li, a} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.BoardComponent',
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
                      Icon glyph: 'cog', fw: true
                      t('rdb.menu.configure_board')
                    ]
                  ]
          h2 @props.board.get 'name'
        ]
        div [
          FullscreenButton id: 'rdb-fullscreen', fullscreen: @state.fullscreen
        ]
      ]
      section className: 'rdb-main', [
        do =>
          engine = @props.board.get("engine")

          switch engine['type']
            when 'taskboard'
              require('./Taskboard')(board: @props.board, engine: engine)
            else
              'Unknown board engine!'
      ]
    ]
