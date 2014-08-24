t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
{div, h3, ul} = require 'rui/DOM'

Issue = require 'rdb/Issue'
Dashboard = require 'rdb/Dashboard'
Configuration = require 'rdb/Configuration'
GlobalEventBus = require 'rdb/GlobalEventBus'
IssueComponent = require 'rdb/IssueComponent'
BackboneMixins = require 'rdb/BackboneMixins'

Column = core.createComponent 'rdb.Taskboard.Column',
  mixins: [BackboneMixins.CollectionView]

  getDefaultProps: ->
    collection: new Issue.Collection board: @props.board, params: {column: @props.id}

  componentDidMount: ->
    @props.collection.fetch().then => @forceUpdate()

  render: ->
    div className: "rdb-column rdb-column-#{@props.id}", [
      h3 @props.name

      ul @renderCollectionItems (item) ->
        IssueComponent model: item
    ]

ColumnConfiguration = core.createComponent 'rdb.Taskboard.ColumnConfiguration',
  render: ->
    h3 t('rdb.configure.columns.title')

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
        h3 t('rdb.configure.swimlanes.title')
    ]

module.exports =
  Main: Main
  Configuration: Configuration
