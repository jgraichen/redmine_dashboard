core = require 'rui/core'
util = require 'rui/util'
GlobalEventBus = require '../mixins/GlobalEventBus'
{div} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.Planboard',
  mixins: [GlobalEventBus],

  render: ->
    div className: 'rdb-main-board rdb-planboard', @renderColumns()

  renderColumns: ->
    div [ "Planboard" ]
