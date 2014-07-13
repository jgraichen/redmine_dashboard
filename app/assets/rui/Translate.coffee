React = require 'react'
extend = require 'extend'
translate = require 'counterpart'

core = require './core'
{span} = require './DOM'
Interpolate = require './Interpolate'

t = (key, opts) ->
  opts ||= {}
  if process.env.NODE_ENV == 'production'
    opts.fallback = translate(key, extend({}, opts, locale: 'en'))
  translate key, opts

Translate = core.createComponent 'rui.Translate',
  render: ->
    component = @props.component || span

    props = extend {}, @props
    delete props.key
    delete props.component

    for key, val of props
      if React.isValidComponent(val)
        props[key] = "%(#{key})s"

    @transferPropsTo Interpolate format: t(@props.key, props)

Translate.counterpart = translate
Translate.t = t

module.exports = Translate
