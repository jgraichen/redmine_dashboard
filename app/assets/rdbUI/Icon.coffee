# RdbUI Button
core = require './core'
{i} = require './DOM'

Icon = core.createComponent 'RdbUI.Icon',
    render: ->
      css = "fa fa-#{@props.name}"
      css += ' fa-fw' if @props.fixedWidth

      @transferPropsTo i className: css

module.exports = Icon
