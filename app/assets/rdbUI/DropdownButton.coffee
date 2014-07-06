extend = require 'extend'

core = require './core'
{span} = require './DOM'
Button = require './Button'
DropdownContainer = require './DropdownContainer'
LayeredComponentMixin = require './LayeredComponentMixin'

DropdownButton = core.createComponent 'RdbUI.DropdownButton',
  mixins: [LayeredComponentMixin]

  getInitialState: ->
    open: false

  renderLayer: ->
    if @state.open
      DropdownContainer
        target: @getDOMNode(),
        @props.children

  render: ->
    props = extend {}, @props
    delete props.label

    extend props, onClick: @toggleDropdown

    Button props, @props.label

  toggleDropdown: (e) ->
    e.preventDefault()
    @setState open: !@state.open

module.exports = DropdownButton
