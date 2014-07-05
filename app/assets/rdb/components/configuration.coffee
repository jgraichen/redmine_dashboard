UI = require('../../rdbUI')

{div, section, header, h1, h2, a} = UI.DOM
{Button, Icon, Navigation, NavigationPane, Observer, Translate, Interpolate} = UI

module.exports = UI.createComponent 'Rdb.ConfigurationComponent',
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
          Button large: true, [
            Icon name: 'ellipsis-v', fixedWidth: true
          ]
        ]
      ]
      Navigation name: 'Configuration', component: section, [
        NavigationPane
          name: 'General'
          help: 'Board name and shared access'
          h2 'General configuration'
        NavigationPane
          name: 'Issue sources'
          help: 'Source projects and issue filters'
          h2 'Sources'
        NavigationPane
          name: 'Columns'
          help: 'Column layout and view options'
          h2 'Columns'
        NavigationPane
          name: 'Swimlanes'
          help: 'Vertical swimlanes to group issues'
          h2 'Swimlanes'
      ]
    ]

