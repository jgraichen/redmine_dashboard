# RdbUI Button
extend = require 'extend'
concat = Array.prototype.concat
classSet = require 'react/lib/cx'

core = require './core'
Icon = require './Icon'
{a, div, button} = require './DOM'

Button = core.createComponent 'rui.Button',
  render: ->
    props = extend {}, @props

    props.className = classSet
      'rui-btn': true,
      'rui-plain': props.plain
      'rui-large': props.large

    children = []
    if props.icon
      children.push Icon glyph: props.icon
      delete props.icon

    children.push props.label || props.children

    if props.href
      component = a
    else
      component = button

    component props, concat.apply([], children)

module.exports = Button
