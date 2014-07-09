# RdbUI Button
map = require('react').Children.map

core = require './core'
util = require './util'
{div, nav, ul, li, a, span, section, h3} = require './DOM'

Navigation = core.createComponent 'rui.Navigation',
  getInitialState: ->
    current: 0

  setCurrent: (index, e) ->
    if index >= 0 && index < @props.children.length
      e?.preventDefault()
      @setState current: index

  render: ->
    tag = @props.component || div
    @transferPropsTo tag className: 'rui-nav', [
      nav [
        h3 @props.name
        ul [
          map @props.children, (pane, index) =>
            li [
              do =>
                content = [ span pane.props.name ]
                if pane.props.help
                  content.push span className: 'help', pane.props.help

                a
                  ref: index
                  tabIndex: 0
                  onClick: (e) => if util.isPrimaryClick(e) then @setCurrent index, e
                  onKeyPress: (e) => if e.keyCode == 13 then @setCurrent index, e
                  className: if @state.current == index then 'active'
                  content
            ]
          ]
      ]
      section [
        map @props.children, (pane, index) =>
          cs = 'rui-nav-pane'
          cs += ' active' if @state.current == index
          div className: cs, [pane]
      ]
    ]

module.exports = Navigation
