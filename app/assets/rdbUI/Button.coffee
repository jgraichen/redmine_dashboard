# RdbUI Button
classSet = require 'react/lib/cx'

core = require './core'
{div, button} = require './DOM'

Button = core.createComponent 'RdbUI.Button',
  render: ->
    meta =
      className: classSet
        'rdbUI-btn': true,
        'rdbUI-btn-plain': @props.btnStyle == 'plain'
        'rdbUI-btn-danger': @props.btnStyle == 'danger'
        'rdbUI-btn-primary': @props.btnStyle == 'primary'
        'rdbUI-btn-success': @props.btnStyle == 'success'
        'rdbUI-btn-subtile': @props.btnStyle == 'subtile'
        'rdbUI-large': @props.large

    @transferPropsTo button meta, (@props.label || @props.children)

module.exports = Button
