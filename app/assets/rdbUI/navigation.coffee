# RdbUI Button

core = require('./core')
ReactChildren = require('react/lib/ReactChildren')

{div, nav, ul, li, a, span, section, h3} = core.DOM

#
module.exports =
  Navigation: core.createComponent 'RdbUI.Navigation',
    getInitialState: ->
      current: 0

    setCurrent: (index) ->
      @setState current: index

    render: ->
      tag = @props.component || div
      @transferPropsTo tag className: 'rdbUI-nav', [
        nav [
          h3 @props.name
          ul [
            ReactChildren.map @props.children, (pane, index) =>
              li [
                do =>
                  content = [ span pane.props.name ]
                  if pane.props.help
                    content.push span className: 'help', pane.props.help

                  a
                    onClick: (e) =>
                      e.preventDefault()
                      @setCurrent index
                    className: if @state.current == index then 'active'
                    content
              ]
            ]
        ]
        section [
          ReactChildren.map @props.children, (pane, index) =>
            cs = 'rdbUI-nav-pane'
            cs += ' active' if @state.current == index
            div className: cs, [pane]
        ]
      ]

  NavigationPane: core.createComponent 'RdbUI.NavigationPane',
    render: ->
      @props.children
