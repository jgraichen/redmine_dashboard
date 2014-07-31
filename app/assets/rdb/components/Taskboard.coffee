core = require 'rui/core'
util = require 'rui/util'
GlobalEventBus = require '../mixins/GlobalEventBus'
{div} = require 'rui/DOM'

TaskboardColumn = require './TaskboardColumn'

module.exports = core.createComponent 'rdb.Taskboard',
  mixins: [GlobalEventBus],

  render: ->
    div className: 'rdb-main-board rdb-taskboard', @renderColumns()

  renderColumns: ->
    @props.engine['columns'].map (column) =>
      TaskboardColumn
        key: column['id']
        board: @props.board
        engine: @props.engine
        name: column['name']
        id: column['id']
