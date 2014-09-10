classSet = require 'react/lib/cx'

core = require './core'
{img} = require './DOM'

Avatar = core.createComponent 'rui.Avatar',
  render: ->
    cs = classSet
      'rui-avatar': true

    @transferPropsTo img className: cs

module.exports = Avatar
