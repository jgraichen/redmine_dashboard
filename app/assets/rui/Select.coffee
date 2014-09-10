# RdbUI Button
extend = require 'extend'
cx = require 'react/lib/cx'

core = require './core'
util = require './util'
Icon = require './Icon'
Attachment = require './Attachment'
KeyboardFocus = require './KeyboardFocus'
LayeredComponent = require './LayeredComponent'
GlobalEventListener = require './GlobalEventListener'
{div, span, a, ul, li} = require './DOM'

Select = core.createComponent 'rui.Select',
  mixins: [KeyboardFocus, LayeredComponent, GlobalEventListener]

  getInitialState: ->
    if @props.value?
      value: @props.value
      current: @props.items.indexOf @props.value
    else
      value: @props.items[0]
      current: 0

  value: ->
    @state.value

  renderLayer: ->
    style =
      width: @getDOMNode().offsetWidth

    cs = cx
      'rui-select-options': true
      'rui-hidden': !@state.visible

    Attachment
      source: @getDOMNode()
      target: @getDOMNode()
      onCloseRequest: => @setState visible: false, active: false
      div className: cs, style: style, ul [
        @props.items.map (item, index) =>
          li
            className: cx 'rui-select-current': @state.current == index
            onClick: (e) =>
              if util.isPrimary e
                @onSelect index
                false
            onMouseOver: => @setState current: index
            onMouseUp: => @onSelect(index) if @state.active
            @props.renderItem item
      ]

  render: ->
    cs = cx
      'rui-select': true
      'active': @state.visible
      'focus': @isFocused()

    div
      tabIndex: 0
      className: cs
      onMouseDown: (e) =>
        if util.isPrimary e
          @setState visible: !@state.visible, active: !@state.visible
          @getDOMNode().focus()
          false
      [
        span className: 'rui-select-label', @props.renderValue @state.value
        Icon glyph: 'caret-down'
      ]

  onSelect: (index) ->
    @setState value: @props.items[index], visible: false, active: false
    @getDOMNode().focus()

  componentDidUpdate: ->
    Attachment.update()

  onKeyDown: (e) ->
    return unless e.target == @getDOMNode()

    if e.keyCode in [13, 32]
      if @state.visible && e.keyCode == 13
        @onSelect @state.current
      else
        @setState visible: !@state.visible, active: !@state.visible
      return false

    if e.keyCode in [27]
      @setState visible: false, active: false
      return false

    if @state.visible
      if e.keyCode in [38]
        @setState current: @state.current - 1 if @state.current > 0
        return false

      if e.keyCode in [40]
        @setState current: @state.current + 1 if @state.current < @props.items.length - 1
        return false

  componentDidMount: ->
    @addGlobalEventListener 'keydown', @onKeyDown

module.exports = Select
