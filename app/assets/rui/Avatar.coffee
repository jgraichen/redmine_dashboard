classSet = require 'react/lib/cx'

core = require './core'
{img, span} = require './DOM'

Avatar = core.createComponent 'rui.Avatar',
  render: ->
    cs = classSet
      'rui-avatar': true

    cs += ' #{@props.className}' if @props.className?

    @transferPropsTo span className: cs,
      img src: @props.src

module.exports = Avatar
