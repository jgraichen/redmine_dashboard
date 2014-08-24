t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'

{table, span} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.Generic.PermissionEditor',
  renderRows: ->
    # @props.board.get('permissions').forEach (perm) ->
    #   tr [
    #     td className: "rdb-permissions-type-#{perm['type']}", perm['name']
    #     td
    #   ]
    span()

  render: ->
    table className: 'rdb-permissions rdb-permissions-editor', @renderRows()
