core = require 'rui/core'
util = require 'rui/util'
GlobalEventBus = require '../mixins/GlobalEventBus'
{div} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.Taskboard',
  mixins: [GlobalEventBus],

  render: ->
    div className: 'rdb-main rdb-taskboard', 'Taskboard'

