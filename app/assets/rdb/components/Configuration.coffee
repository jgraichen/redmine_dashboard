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

{div, section, header, h1, h2, h3, a, p, label} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.ConfigurationComponent',
  render: ->
    backToBoard = (e) =>
      util.handlePrimaryClick e, (e) =>
        Rdb.events.trigger 'navigate', @props.board.urls.root

    div [
      header className: 'rdb-header', [
        div [
          Button
            id: 'rdb-return'
            icon: 'chevron-left'
            onClick: backToBoard
            'href': @props.board.urls.root
            'title': Translate.t('rdb.menu.return_to_dashboard')
            'aria-label': Translate.t('rdb.menu.return_to_dashboard')
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
        Navigation id: 'cfg', name: Translate.t('rdb.configure.nav_title'), [
          div
            name: Translate.t('rdb.configure.general.nav')
            help: Translate.t('rdb.configure.general.nav_text')
            [
              h2 Translate.t('rdb.configure.general.title')
              p Translate.t('rdb.configure.general.description')
              h3 Translate.t('rdb.configure.general.general')
              Input
                label: Translate.t('rdb.configure.general.dashboard_name')
                value: @props.board.get('name')
                onSave: (val) =>
                  @props.board.save({'name': val}, wait: true)
                    .catch (xhr) =>
                      throw new Input.Error JSON.parse(xhr.responseText)?['errors']?['name']
            ]
          div
            name: Translate.t('rdb.configure.sources.nav')
            help: Translate.t('rdb.configure.sources.nav_text')
            h2 Translate.t('rdb.configure.sources.title')
          div
            name: Translate.t('rdb.configure.columns.nav')
            help: Translate.t('rdb.configure.columns.nav_text')
            h2 Translate.t('rdb.configure.columns.title')
          div
            name: Translate.t('rdb.configure.swimlanes.nav')
            help: Translate.t('rdb.configure.swimlanes.nav_text')
            h2 Translate.t('rdb.configure.swimlanes.title')
        ]
      ]
    ]
