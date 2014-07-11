extend  = require 'extend'
invariant = require 'react/lib/invariant'

core = require './core'
{span} = require './DOM'

isString = (object) ->
  Object.prototype.toString.call(object) == '[object String]'

REGEXP = /\%\((.+?)\)s/

Interpolate = core.createComponent 'rui.Interpolate',
  getDefaultProps: ->
    component: span

  render: ->
    format    = @props.children || @props.format
    component = @props.component
    props     = extend {}, @props

    if process.env.NODE_ENV == "development"
      invariant isString(format), 'Format must be a string value'

    args = format.split(REGEXP).reduce (memo, match, index) ->
      if index % 2 == 0
        if match.length > 0
          memo.push match
      else
        memo.push props[match]
      memo
    , []

    component props, args

module.exports = Interpolate
