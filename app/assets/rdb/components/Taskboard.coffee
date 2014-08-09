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
    @props.board.get('columns').map (column) =>
      TaskboardColumn
        key: column['id']
        board: @props.board
        name: column['name']
        id: column['id']
