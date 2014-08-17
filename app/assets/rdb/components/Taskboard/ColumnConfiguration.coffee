t = require 'counterpart'

core = require 'rui/core'
{div, h2} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.Taskboard.ColumnConfiguration',
  render: ->
    h2 t('rdb.configure.columns.title')
