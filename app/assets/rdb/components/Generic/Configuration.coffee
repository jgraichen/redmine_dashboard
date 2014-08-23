t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Input = require 'rui/Input'

{section, h2, h3, p, label, span} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.Generic.Configuration',
  render: ->
    section [
      h2 t('rdb.configure.general.title')
      p t('rdb.configure.general.description')
      h3 t('rdb.configure.general.general')
      Input
        label: t('rdb.configure.general.dashboard_name')
        help: t('rdb.configure.general.dashboard_name_text')
        value: @props.board.get('name')
        onSave: (val) =>
          @props.board.save({'name': val}, wait: true, patch: true  )
            .catch (xhr) =>
              throw new Input.Error JSON.parse(xhr.responseText)?['errors']?['name']
      # Input
      #   label: t('rdb.configure.general.dashboard_type')
      #   help: t('rdb.configure.general.dashboard_type_text')
      #   value: @props.board.get('type')
      #   onSave: (val) =>
      #     @props.board.save({'type': val}, wait: true)
      #       .catch (xhr) =>
      #         throw new Input.Error JSON.parse(xhr.responseText)?['errors']?['type']
    ]
