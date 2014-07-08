# RdbUI Button
core = require './core'
{i} = require './DOM'

Icon = core.createComponent 'rui.Icon',
    render: ->
      @transferPropsTo i className: 'oi rui-icon', 'data-glyph': @props.glyph

module.exports = Icon
