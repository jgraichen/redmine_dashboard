# RdbUI Button
map = require('react').Children.map
classSet = require 'react/lib/cx'

core = require './core'
util = require './util'
KeyboardFocus = require './KeyboardFocus'
{div, nav, ul, li, a, span, section, h4} = require './DOM'

NavigationLink = core.createComponent 'rui.NavigationLink',
  mixins: [KeyboardFocus]

  render: ->
    cs = classSet
      'active': @props.active
      'focus': @state.focus

    @transferPropsTo a
      tabIndex: 0
      className: cs
      onClick: (e) =>
        if util.isPrimaryClick(e)
          e.preventDefault()
          @props.onActivation(@props.index)
      onKeyPress: (e) =>
        if e.keyCode == 13
          e.preventDefault()
          @props.onActivation(@props.index)
      @props.children


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
        h4 @props.name
        ul [
          map @props.children, (pane, index) =>
            li [
              do =>
                content = [ span pane.props.name ]
                if pane.props.help
                  content.push span className: 'help', pane.props.help

                NavigationLink
                  ref: index
                  index: index
                  active: @state.current == index
                  onActivation: (index) => @setCurrent index
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
