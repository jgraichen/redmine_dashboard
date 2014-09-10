t = require 'counterpart'
cx = require 'react/lib/cx'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Menu = require 'rui/Menu'
Button = require 'rui/Button'
Attachment = require 'rui/Attachment'
LayeredComponent = require 'rui/LayeredComponent'
{h2, div, section, header, span, a} = require 'rui/DOM'

Rdb = require 'rdb/index'
BoardMenu = require 'rdb/BoardMenu'
GlobalEventBus = require 'rdb/GlobalEventBus'

module.exports =
  mixins: [GlobalEventBus, LayeredComponent],

  events:
    'rdb:fullscreen:changed': 'setFullscreenState'

  getInitialState: ->
    fullscreen: false
    open: false

  setFullscreenState: (state) ->
    @setState fullscreen: state

  renderLayer: ->
    cs = cx
      'rui-hidden': !@state.open

    Attachment
      target: @refs['header'].getDOMNode(),
      BoardMenu
        board: @props.board
        className: cs

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
            if util.isPrimary e
              Rdb.events.trigger 'rdb:fullscreen:toggle'
              false
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
                if util.isPrimary e
                  @setState open: !@state.open
                  false
              [
                Icon glyph: 'chevron-circle-down'
                @props.board.get 'name'
              ]
      ]

      section className: 'rdb-main', @renderBoard()
    ]
