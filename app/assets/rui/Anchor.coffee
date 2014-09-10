extend = require 'extend'
concat = Array.prototype.concat
classSet = require 'react/lib/cx'

core = require './core'
util = require './util'
Icon = require './Icon'
KeyboardFocus = require './KeyboardFocus'
{a, div, button} = require './DOM'

Anchor = core.createComponent 'rui.Anchor',
  mixins: [KeyboardFocus]

  render: ->
    props = extend {}, @props

    props.onClick = (e) ->
      props.onPrimary?(e) if util.isPrimary(e)

    props.href = '#' unless props.href?

    props.className ?= ''
    props.className += ' ' + classSet
      'focus': @state.focus
      'rui-anchor': true
    props.className = props.className.trim()

    children = []
    if props.icon
      children.push Icon glyph: props.icon
      delete props.icon

    children.push props.label || props.children

    a props, concat.apply([], children)

module.exports = Anchor
