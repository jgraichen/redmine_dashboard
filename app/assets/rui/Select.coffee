# RdbUI Button
extend = require 'extend'
classSet = require 'react/lib/cx'

core = require './core'
KeyboardFocus = require './KeyboardFocus'
DropdownButton = require './DropdownButton'
{select, option, span, ul, li, a} = require './DOM'

Select = core.createComponent 'rui.Select',
  mixins: [KeyboardFocus]

  render: ->
    select className: 'rui-select', @props.children

Select.Option = core.createComponent 'rui.Option',
  render: ->
    option value: @props.value, @props.children

module.exports = Select
