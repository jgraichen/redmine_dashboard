t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Form = require 'rui/Form'
Input = require 'rui/Input'
Anchor = require 'rui/Anchor'

{section, h3, h4, p, label,
 span, table, tr, td, a, img, th} = require 'rui/DOM'

PermissionComponents = require 'rdb/PermissionComponents'

module.exports = core.createComponent 'rdb.GeneralConfiguration',
  render: ->
    section className: 'rdb-configuration', [
      h3 t('rdb.configure.general.title')
      p t('rdb.configure.general.description')
      @renderGeneral()
      @renderPermissions()
    ]

  renderGeneral: ->
    section [
      h4 t('rdb.configure.general.general')
      Form.Input
        label: t('rdb.configure.general.dashboard_name')
        help: t('rdb.configure.general.dashboard_name_text')
        value: @props.board.getName()
        autosubmit: 1000
        tick: true
        onSubmit: (val) =>
          @props.board
            .save {'name': val}, wait: true, patch: true
            .catch (err) =>
              if err.xhr.status == 422
                throw new Input.Error err.xhr.responseJSON['errors']['name'], 'board_name'
              throw err
    ]

  renderPermissions: ->
    section [
      h4 t('rdb.configure.general.access_control')
      PermissionComponents.Editor board: @props.board
    ]
