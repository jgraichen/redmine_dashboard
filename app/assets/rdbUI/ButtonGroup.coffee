core  = require 'rdbUI/core'
{div} = require 'rdbUI/DOM'

ButtonGroup = core.createComponent 'RdbUI.ButtonGroup',
  render: ->
    @transferPropsTo div className: 'rdbUI-btn-group', @props.children
