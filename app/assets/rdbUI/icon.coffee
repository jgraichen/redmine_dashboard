# RdbUI Button
core = require './core'

{i} = core.DOM

module.exports =
  Icon: core.createComponent 'RdbUI.Icon',
    render: ->
      css = "fa fa-#{@props.name}"
      css += ' fa-fw' if @props.fixedWidth

      @transferPropsTo i className: css
