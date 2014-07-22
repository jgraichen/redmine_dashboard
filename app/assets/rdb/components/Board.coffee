t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
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
                label: [ Icon glyph: 'dot-circle-o', large: true ]
                target: '#rdb-board > header'
                ul [
                    li [
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
                    ]
                  ]
          h2 @props.board.get 'name'
        ]
        div [
          FullscreenButton id: 'rdb-fullscreen', fullscreen: @state.fullscreen
        ]
      ]
      do =>
        engine = @props.board.get("engine")

        switch engine['type']
          when 'taskboard'
            require('./Taskboard')(board: @props.board, engine: engine)
          else
            section className: 'rdb-main', 'Unknown board engine!'
    ]

