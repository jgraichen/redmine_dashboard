extend = require 'extend'

core = require './core'
util = require './util'
Icon = require './Icon'
{span} = require './DOM'
Button = require './Button'
Dropdown = require './Dropdown'
LayeredComponentMixin = require './LayeredComponentMixin'

DropdownButton = core.createComponent 'rui.DropdownButton',
  mixins: [LayeredComponentMixin]

  getInitialState: ->
    open: false

  renderLayer: ->
    if @props.target
      target = document.querySelector @props.target
    else
      target = @getDOMNode()

    Dropdown
      target: target,
      visible: @state.open
      @props.children

  render: ->
    props = extend {}, @props

    props.className += ' active' if @state.open
    delete props.label

    props.onClick = (e) =>
      util.handlePrimaryClick e, (e) =>
        @setState open: !@state.open

    Button props, [ @props.label, Icon glyph: 'caret-down' ]

module.exports = DropdownButton
