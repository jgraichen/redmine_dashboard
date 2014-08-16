t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Menu = require 'rui/Menu'
{a} = require 'rui/DOM'

BoardCollection = require '../resources/BoardCollection'

module.exports = core.createComponent 'rdb.BoardMenu',
  getInitialState: ->
    boards: new BoardCollection()

  componentDidMount: ->
    @state.boards.on 'change add', @update, @
    @state.boards.fetch()

  componentWillUnmount: ->
    @state.boards.off null, null, @

  update: ->
    @forceUpdate()

  renderConfigItem: ->
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
    items = [@renderConfigItem(), @renderCreateItem(), Menu.Separator()]
    @state.boards.forEach (board) ->
      items.push a
        href: board.urls.root
        board.get 'name'

    Menu items
