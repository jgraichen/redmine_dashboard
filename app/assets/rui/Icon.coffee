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
      'rui-icon': true
      'fa': true
      'fa-flip-vertical': !@props.flip.horizontal && @props.flip.vertical
      'fa-flip-horizontal': @props.flip.horizontal && !@props.flip.vertical
      'fa-flip-horizontal-vertical': @props.flip.horizontal && @props.flip.vertical
      'fa-fw': @props.fixedwidth || @props.fw
      'fa-lg': @props.large

    cs += " fa-#{@props.glyph}"

    @transferPropsTo i className: cs, 'data-glyph': @props.glyph

module.exports = Icon
