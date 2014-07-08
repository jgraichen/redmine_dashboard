
core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
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
        Rdb.events.trigger 'navigate', '/'

    div [
      header className: 'rdb-header', [
        div [
          Button
            icon: 'chevron-left'
            onClick: backToBoard
          Observer
            watch: @props.board
            event: 'change:name'
            render: =>
              Translate
                key: 'rdb.header.configure.header'
                component: h2
                link: a
                  href: @props.board.url.base
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
            h2 'General configuration'
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
