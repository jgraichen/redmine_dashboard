# RdbUI Button
React = require 'react'
extend = require 'extend'
concat = Array.prototype.concat
classSet = require 'react/lib/cx'

core = require './core'
Icon = require './Icon'
KeyboardFocus = require './KeyboardFocus'
{a, div, button, span} = require './DOM'

Button = core.createComponent 'rui.Button',
  mixins: [KeyboardFocus]

  render: ->
    props = extend {}, @props

    props.className += ' ' + classSet
      'focus': @isFocused()
      'rui-btn': true,
      'rui-plain': props.plain
      'rui-large': props.large

    children = []
    if props.icon
      children.push Icon glyph: props.icon
      delete props.icon

    if props.label?
      children.push props.label
    else
      React.Children.forEach props.children, (c) ->
        children.push c

    if props.href
      component = a
    else
      component = button

    component props, concat.apply([], children)

module.exports = Button
