core  = require './core'
{div} = require './DOM'

ButtonGroup = core.createComponent 'rui.ButtonGroup',
  render: ->
    @transferPropsTo div className: 'rui-btn-group', @props.children
