t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Input = require 'rui/Input'
Anchor = require 'rui/Anchor'

{section, h3, h4, p, label,
 span, table, tr, td, a, img, th} = require 'rui/DOM'

PermissionComponents = require 'rdb/PermissionComponents'

module.exports = core.createComponent 'rdb.GeneralConfiguration',
  render: ->
    section [
      h3 t('rdb.configure.general.title')
      p t('rdb.configure.general.description')
      @renderGeneral()
      @renderPermissions()
    ]

  renderGeneral: ->
    section [
      h4 t('rdb.configure.general.general')
      Input
        label: t('rdb.configure.general.dashboard_name')
        help: t('rdb.configure.general.dashboard_name_text')
        value: @props.board.getName()
        onSave: (val) =>
          @props.board
            .save {'name': val}, wait: true
            .catch (xhr) =>
              throw new Input.Error JSON.parse(xhr.responseText)?['errors']?['name']
    ]

  renderPermissions: ->
    section [
      h4 t('rdb.configure.general.access_control')
      PermissionComponents.Editor board: @props.board
    ]
