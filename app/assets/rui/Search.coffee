# RdbUI Button
extend = require 'extend'
cx = require 'react/lib/cx'

core = require './core'
util = require './util'
Attachment = require './Attachment'
LayeredComponent = require './LayeredComponent'
{div, span, a, ul, li, input} = require './DOM'

Search = core.createComponent 'rui.Search',
  mixins: [LayeredComponent]

  getInitialState: ->
    value: null
    items: []
    current: 0

  value: ->
    @state.value

  renderLayer: ->
    style =
      width: @getDOMNode().offsetWidth

    cs = cx
      'rui-search-results': true
      'rui-hidden': @state.items.length == 0

    Attachment
      source: @getDOMNode()
      target: @getDOMNode()
      onCloseRequest: => @setState items: []
      div className: cs, style: style, ul [
        @state.items.map (item, index) =>
          li [
            a
              key: item['id']
              href: '#'
              className: cx 'rui-search-current': @state.current == index
              onClick: (e) => @onSelect(index) if util.isPrimary(e)
              onMouseOver: => @setState current: index
              @props.renderItem item
          ]
      ]

  onSelect: (index) ->
    @setState value: @state.items[index], items: [], =>
    @refs['input'].getDOMNode().value = ''
    @refs['input'].getDOMNode().focus()

  clear: ->
    @setState value: null, items: []

  focus: ->
    @refs['input'].getDOMNode().focus()

  onKeyDown: (e) ->
    if @state.items.length > 0
      if e.keyCode in [13]
        @onSelect @state.current
        return true

      if e.keyCode in [38]
        @setState current: @state.current - 1 if @state.current > 0
        return false

      if e.keyCode in [40]
        @setState current: @state.current + 1 if @state.current < @state.items.length - 1
        return false

    if @state.value?
      if e.keyCode in [8]
        @setState value: null
        return false

      if e.keyCode in [13] && @props.onSubmit?
        @props.onSubmit @state.value
        return true

  render: ->
    cs = cx
      'rui-search': true
      'focus': @state.focused

    div
      className: cs
      div [
        do => if @state.value?
          span ref: 'result', className: 'rui-search-value', @props.renderValue @state.value
        input
          id: @props.id
          ref: 'input'
          placeholder: if !@state.value? then @props.placeholder
          onKeyDown: @onKeyDown
          onBlur: (e) => @setState focused: false
          onFocus: (e) =>
            @setState focused: true
            if e.target.value.length > 0
              @setState value: null
              @props.query(e.target.value).then (items) =>
                @setState items: items, current: 0
          onChange: (e) =>
            if e.target.value.length == 0
              @setState items: [], current: 0
            else
              @setState value: null
              @props.query(e.target.value).then (items) =>
                @setState items: items, current: 0
      ]

  componentDidUpdate: ->
    Attachment.update()

module.exports = Search
