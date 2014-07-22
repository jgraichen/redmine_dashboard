extend = require 'extend'

core = require './core'
util = require './util'
{span} = require './DOM'
Button = require './Button'
DropdownContainer = require './DropdownContainer'
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

    DropdownContainer
      target: target,
      visible: @state.open
      @props.children

  render: ->
    props = extend {}, @props

    props.className += ' active' if @state.open

    props.onClick = (e) =>
      util.handlePrimaryClick e, (e) =>
        @setState open: !@state.open

    Button props

module.exports = DropdownButton
