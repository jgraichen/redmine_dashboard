Promise = require 'bluebird'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Input = require 'rui/Input'
Button = require 'rui/Button'
Observer = require 'rui/Observer'
Translate = require 'rui/Translate'
Navigation = require 'rui/Navigation'
DropdownButton = require 'rui/DropdownButton'

{div, section, header, h1, h2, h3, a, p, label, span} = require 'rui/DOM'

GenericConfiguration = require 'rdb/components/Generic/Configuration'

module.exports =
  renderCommonConfig: ->
    div
      name: Translate.t('rdb.configure.general.nav')
      help: Translate.t('rdb.configure.general.nav_text')
      GenericConfiguration board: @props.board
      # [
      #   h2 Translate.t('rdb.configure.general.title')
      #   p Translate.t('rdb.configure.general.description')
      #   h3 Translate.t('rdb.configure.general.general')
      #   Input
      #     label: Translate.t('rdb.configure.general.dashboard_name')
      #     help: Translate.t('rdb.configure.general.dashboard_name_text')
      #     value: @props.board.get('name')
      #     onSave: (val) =>
      #       @props.board.save({'name': val}, wait: true, patch: true  )
      #         .catch (xhr) =>
      #           throw new Input.Error JSON.parse(xhr.responseText)?['errors']?['name']
      #   # Input
      #   #   label: Translate.t('rdb.configure.general.dashboard_type')
      #   #   help: Translate.t('rdb.configure.general.dashboard_type_text')
      #   #   value: @props.board.get('type')
      #   #   onSave: (val) =>
      #   #     @props.board.save({'type': val}, wait: true)
      #   #       .catch (xhr) =>
      #   #         throw new Input.Error JSON.parse(xhr.responseText)?['errors']?['type']
      # ]

  render: ->
    backToBoard = (e) =>
      util.handlePrimaryClick e, (e) =>
        Rdb.navigate @props.board.urls.root

    div [
      header className: 'rdb-header', [
        div [
          Button
            id: 'rdb-return'
            onClick: backToBoard
            'href': @props.board.urls.root
            'title': Translate.t('rdb.menu.return_to_dashboard')
            'aria-label': Translate.t('rdb.menu.return_to_dashboard')
            [ Icon glyph: 'chevron-left', large: true ]
          Translate
            key: 'rdb.configure.title'
            component: h2
            link: a
              onClick: backToBoard
              'href': @props.board.urls.root
              'title': Translate.t('rdb.menu.return_to_dashboard')
              'aria-label': Translate.t('rdb.menu.return_to_dashboard')
              @props.board.get 'name'
        ]
        div []
      ]
      section className: 'rdb-main', [
        Navigation id: 'cfg', name: Translate.t('rdb.configure.nav_title'), do =>
          panels = []
          panels.push @renderCommonConfig()
          for panel in @renderConfig()
            panels.push panel

          panels
      ]
    ]
