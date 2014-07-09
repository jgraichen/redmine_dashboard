# RdbUI Button
classSet = require 'react/lib/cx'

core = require './core'
{i} = require './DOM'

Icon = core.createComponent 'rui.Icon',
  getDefaultProps: ->
    flip:
      horizontal: false
      vertical: false

  render: ->
    cs = classSet
      'oi': true
      'rui-icon': true
      'oi-flip-vertical': !@props.flip.horizontal && @props.flip.vertical
      'oi-flip-horizontal': @props.flip.horizontal && !@props.flip.vertical
      'oi-flip-horizontal-vertical': @props.flip.horizontal && @props.flip.vertical

    @transferPropsTo i className: cs, 'data-glyph': @props.glyph

module.exports = Icon
