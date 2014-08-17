t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
{div, h2} = require 'rui/DOM'

Dashboard = require 'rdb/mixins/Dashboard'
Configuration = require 'rdb/mixins/Configuration'
GlobalEventBus = require 'rdb/mixins/GlobalEventBus'

Column = require './Taskboard/Column'
ColumnConfiguration = require './Taskboard/ColumnConfiguration'

Main = core.createComponent 'rdb.Taskboard',
  mixins: [Dashboard],

  renderBoard: ->
    div className: 'rdb-main-board rdb-taskboard', @renderColumns()

  renderColumns: ->
    @props.board.get('columns').map (column) =>
      Column
        key: column['id']
        board: @props.board
        name: column['name']
        id: column['id']

Configuration = core.createComponent 'rdb.Taskboard.Configuration',
  mixins: [Configuration]

  renderConfig: ->
    [
      # div
      #   name: Translate.t('rdb.configure.sources.nav')
      #   help: Translate.t('rdb.configure.sources.nav_text')
      #   h2 Translate.t('rdb.configure.sources.title')
      div
        name: t('rdb.configure.columns.nav')
        help: t('rdb.configure.columns.nav_text')
        ColumnConfiguration board: @props.board
      div
        name: t('rdb.configure.swimlanes.nav')
        help: t('rdb.configure.swimlanes.nav_text')
        h2 t('rdb.configure.swimlanes.title')
    ]

module.exports =
  Main: Main
  Configuration: Configuration
