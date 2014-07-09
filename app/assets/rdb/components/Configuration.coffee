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

{div, section, header, h1, h2, a} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.ConfigurationComponent',
  render: ->
    backToBoard = (e) =>
      util.handlePrimaryClick e, (e) =>
        Rdb.events.trigger 'navigate', @props.board.urls.root

    div [
      header className: 'rdb-header', [
        div [
          Button
            icon: 'chevron-left'
            href: @props.board.urls.root
            onClick: backToBoard
          Translate
            key: 'rdb.header.configure.header'
            component: h2
            link: a
              href: @props.board.urls.root
              onClick: backToBoard
              @props.board.get 'name'
        ]
        div []
      ]
      section className: 'rdb-main', [
        Navigation id: 'cfg', name: 'Configuration', [
          div
            name: 'General'
            help: 'Board name and shared access'
            [
              h2 'General configuration'
              Input
                value: @props.board.get('name')
                onSave: (val) =>
                  @props.board.save({'name': val}, wait: true)
                    .catch (xhr) =>
                      throw new Input.Error JSON.parse(xhr.responseText)?['errors']?['name']
            ]
          div
            name: 'Issue sources'
            help: 'Source projects and issue filters'
            h2 'Sources'
          div
            name: 'Columns'
            help: 'Column layout and view options'
            h2 'Columns'
          div
            name: 'Swimlanes'
            help: 'Vertical swimlanes to group issues'
            h2 'Swimlanes'
        ]
      ]
    ]
