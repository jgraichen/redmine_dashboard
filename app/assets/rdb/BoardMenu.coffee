t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Menu = require 'rui/Menu'
{a} = require 'rui/DOM'

Board = require 'rdb/Board'

module.exports = core.createComponent 'rdb.BoardMenu',
  getInitialState: ->
    boards: new Board.Collection()

  componentDidMount: ->
    @state.boards.on 'change add', @update, @
    @state.boards.fetch()

  componentWillUnmount: ->
    @state.boards.off null, null, @

  update: ->
    @forceUpdate()

  renderCreateItem: ->
    a
      href: @props.board.urls.create
      'title': t('rdb.menu.create_new_board')
      'aria-label': t('rdb.menu.create_new_board')
      [
        Icon glyph: 'plus'
        t('rdb.menu.create_new_board')
      ]

  render: ->
    items = [@renderCreateItem(), Menu.Separator()]
    @state.boards.forEach (board) ->
      items.push a
        href: board.urls.root
        board.get 'name'

    Menu items
