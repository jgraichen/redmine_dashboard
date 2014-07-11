React = require 'react'
extend = require 'extend'
translate = require 'counterpart'

core = require './core'
{span} = require './DOM'
Interpolate = require './Interpolate'

Translate = core.createComponent 'rui.Translate',
  render: ->
    component = @props.component || span

    props = extend {}, @props
    delete props.key
    delete props.component

    for key, val of props
      if React.isValidComponent(val)
        props[key] = "%(#{key})s"

    @transferPropsTo Interpolate format: translate(@props.key, props)

Translate.counterpart = translate

module.exports = Translate
