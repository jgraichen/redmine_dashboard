React = require 'react'
cx = require 'react/lib/cx'
t = require 'counterpart'
$ = React.createElement

Attachment = require 'molecule/lib/attachment'
Component = require 'molecule/lib/component'
Layered = require 'molecule/lib/mixins/layered'
Panel = require 'molecule/lib/panel'
Link = require 'molecule/lib/link'
Icon = require 'molecule/lib/icon'
Menu = require 'molecule/lib/menu'

Observer = require './mixins/observer'
Navigate = require './navigate'
Events = require '../events'
Board = require '../resources/board'
util = require '../util'

class Dashboard extends Component
  @include Events.Mixin
  @include Layered
  @include Observer, prop: 'board', on: 'change'

  events:
    setFullscreenState: 'fullscreen:toggled'

  constructor: (props) ->
    @state = fullscreen: false, open: false

  setFullscreenState: (state) ->
    @setState fullscreen: state

  render: ->
    @props.wrapper [
      $ 'div', className: 'contextual', [
        do =>
          if !@state.fullscreen
            $ Navigate,
              href: @props.board.rel.configure
              [
                $ Icon, glyph: 'pencil'
                t 'rdb.contextual.configure'
              ]
        $ Link,
          href: '#'
          onAction: (e) =>
            e.preventDefault()
            Events.trigger 'fullscreen:toggle'
          [
            $ Icon, glyph: 'arrows-alt'
            t 'rdb.contextual.fullscreen'
          ]
        ]
      $ 'h2', ref: 'header', [
        do =>
          if @state.fullscreen
            @props.board.get 'name'
          else
            $ Link,
              id: 'rdb-menu',
              ref: 'menu'
              onAction: (e) =>
                e.preventDefault()
                @setState open: !@state.open
              [
                $ Icon, glyph: 'chevron-circle-down'
                @props.board.get 'name'
              ]
      ]

      $ 'section', className: 'rdb-main', @renderBoard()
    ]

  renderLayer: =>
    return unless @state.open

    target = React.findDOMNode @refs['header']

    $ Attachment,
      target: target
      onCloseRequest: =>
        @setState open: false
      $ Dashboard.BoardMenu,
        collection: new Board.Collection()
        board: @props.board


class Dashboard.BoardMenu extends Component
  @include Observer, prop: 'collection', on: 'add remove reset'

  componentDidMount: =>
    super()
    @props.collection.fetch()

  renderComponent: (props) =>
    $ Panel, null, [
      $ Menu, null, [
        $ Menu.List, null, [
          $ Menu.Item,
            icon: 'plus'
            href: util.url @props.board.rel.create
            t 'rdb.menu.create_new_board'
        ]
        $ Menu.List, null, @props.collection.map (board) =>
          $ Menu.Item,
            href: util.url board.rel.show
            board.get 'name'
      ]
    ]

module.exports = Dashboard
