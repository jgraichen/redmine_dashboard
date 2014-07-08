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
    if @state.open
      DropdownContainer
        target: @getDOMNode(),
        @props.children

  render: ->
    @transferPropsTo Button onClick: (e) =>
      util.handlePrimaryClick e, (e) =>
        @setState open: !@state.open

module.exports = DropdownButton
