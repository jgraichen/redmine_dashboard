# RdbUI Button
core = require './core'
cx = require 'react/lib/cx'

{div, button} = core.DOM

module.exports =
  Button: core.createComponent 'RdbUI.Button',
    render: ->
      cs = cx
        'rdbUI-btn': true,
        'rdbUI-btn-plain': @props.style == 'plain'
        'rdbUI-btn-danger': @props.style == 'danger'
        'rdbUI-btn-primary': @props.style == 'primary'
        'rdbUI-btn-success': @props.style == 'success'
        'rdbUI-btn-subtile': @props.style == 'subtile'
        'rdbUI-large': @props.large

      button
        className: cs
        onClick: @props.onClick
        @props.children

  ButtonGroup: core.createComponent 'RdbUI.ButtonGroup',
    render: ->
      @transferPropsTo div className: 'rdbUI-btn-group', @props.children
