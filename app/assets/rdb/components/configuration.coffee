core = require 'rdbUI/core'
Observer = require 'rdbUI/Observer'
DropdownButton = require 'rdbUI/DropdownButton'
Navigation = require 'rdbUI/Navigation'
Icon = require 'rdbUI/Icon'

{div, section, header, h1, h2, a} = require 'rdbUI/DOM'

module.exports = core.createComponent 'Rdb.ConfigurationComponent',
  render: ->
    div id: 'redmine-dashboard', [
      header [
        div [
          # Translate
          #   key: 'rdb.header.configure.header'
          #   component: h2
          #   link:
          Observer
            watch: @props.board
            event: 'change:name'
            render: =>
              h2 [
                a
                  href: @props.board.url.base
                  onClick: (e) => Rdb.app.goTo e, @props.board.url.base
                  @props.board.get 'name'
              ]
        ]
        div [
          DropdownButton
            large: true
            label: Icon name: 'ellipsis-v', fixedWidth: true
            [
              section "Container content X"
            ]
        ]
      ]
      Navigation name: 'Configuration', component: section, [
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
