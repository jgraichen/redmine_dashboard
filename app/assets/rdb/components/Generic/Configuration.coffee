t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Input = require 'rui/Input'

{section, h3, h4, p, label, span} = require 'rui/DOM'

PermissionEditor = require './PermissionEditor'

module.exports = core.createComponent 'rdb.Generic.Configuration',
  render: ->
    section [
      h3 t('rdb.configure.general.title')
      p t('rdb.configure.general.description')
      h4 t('rdb.configure.general.general')
      Input
        label: t('rdb.configure.general.dashboard_name')
        help: t('rdb.configure.general.dashboard_name_text')
        value: @props.board.get('name')
        onSave: (val) =>
          @props.board.save({'name': val}, wait: true, patch: true  )
            .catch (xhr) =>
              throw new Input.Error JSON.parse(xhr.responseText)?['errors']?['name']
      h4 t('rdb.configure.general.access_control')
      PermissionEditor board: @props.board
    ]
