classSet = require('react/lib/cx')

core = require 'rdbUI/core'
Icon = require 'rdbUI/Icon'
Button = require 'rdbUI/Button'
DropdownButton = require 'rdbUI/DropdownButton'
{h1, div, section, header, span} = require 'rdbUI/DOM'

module.exports = core.createComponent 'Rdb.BoardComponent',
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
          DropdownButton
            large: true
            btnStyle: 'subtile'
            label: @props.board.get 'name'
            [
              h1 "CONTENT"
            ]
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

