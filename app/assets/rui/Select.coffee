# RdbUI Button
extend = require 'extend'
classSet = require 'react/lib/cx'

core = require './core'
KeyboardFocus = require './KeyboardFocus'
DropdownButton = require './DropdownButton'
{select, option, span, ul, li, a} = require './DOM'

Select = core.createComponent 'rui.Select',
  mixins: [KeyboardFocus]

  getInitialState: ->
    value: @props.children[0]?.props.value

  value: ->
    @state.value

  render: ->
    select
      className: 'rui-select'
      value: @state.value
      onChange: (e) =>
        @setState value: e.target.value
      @props.children

Select.Option = core.createComponent 'rui.Option',
  render: ->
    option value: @props.value, @props.children

module.exports = Select
