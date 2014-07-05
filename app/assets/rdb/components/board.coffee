UI = require('../../rdbUI')
classSet = require('react/lib/cx')

{div, section, header, span} = UI.DOM
{Button, Icon, Observer} = UI

module.exports = UI.createComponent 'Rdb.BoardComponent',
  getInitialState: ->
    fullscreen: false

  toggleFullscreen: ->
    @setState fullscreen: (if @state.fullscreen then false else true)

  render: ->
    cs = classSet
      'rdb-fullscreen': @state.fullscreen

    div id: 'redmine-dashboard', className: cs, [
      header [
        div [
          Button
            large: true
            style: 'subtile'
            @props.board.get 'name'
        ]
        div [
          Button
            large: true
            onClick: (e) => Rdb.app.goTo e, @props.board.url.configure
            Icon
              name: 'gear'
              fixedWidth: true
          Button
            large: true
            onClick: this.toggleFullscreen
            Icon
              name: (if @state.fullscreen then 'angle-double-down' else 'angle-double-up')
              fixedWidth: true
        ]
      ]
      (section "X")
    ]

