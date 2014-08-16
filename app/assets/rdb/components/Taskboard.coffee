core = require 'rui/core'
util = require 'rui/util'
Translate = require 'rui/Translate'
{div, h2} = require 'rui/DOM'

Dashboard = require '../mixins/Dashboard'
Configuration = require '../mixins/Configuration'
GlobalEventBus = require '../mixins/GlobalEventBus'
TaskboardColumn = require './TaskboardColumn'

Main = core.createComponent 'rdb.Taskboard',
  mixins: [Dashboard],

  renderBoard: ->
    div className: 'rdb-main-board rdb-taskboard', @renderColumns()

  renderColumns: ->
    @props.board.get('columns').map (column) =>
      TaskboardColumn
        key: column['id']
        board: @props.board
        name: column['name']
        id: column['id']

Configuration = core.createComponent 'rdb.Taskboard.Configuration',
  mixins: [Configuration]

  renderConfig: ->
    [
      div
        name: Translate.t('rdb.configure.sources.nav')
        help: Translate.t('rdb.configure.sources.nav_text')
        h2 Translate.t('rdb.configure.sources.title')
      div
        name: Translate.t('rdb.configure.columns.nav')
        help: Translate.t('rdb.configure.columns.nav_text')
        h2 Translate.t('rdb.configure.columns.title')
      div
        name: Translate.t('rdb.configure.swimlanes.nav')
        help: Translate.t('rdb.configure.swimlanes.nav_text')
        h2 Translate.t('rdb.configure.swimlanes.title')
    ]

module.exports =
  Main: Main
  Configuration: Configuration
