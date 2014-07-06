React = require 'react'
# Tether = require 'vendor/tether'

core = require './core'
{div, span} = require './DOM'
DropdownPositionMixing = require './DropdownPositionMixing'

DropdownContainer = core.createComponent 'RdbUI.DropdownContainer',
  mixins: [DropdownPositionMixing]
  # getDefaultProps: ->
  #   attachment: 'top left'
  #   targetAttachment: 'bottom left'

  # componentDidMount: ->
  #   @node = document.createElement 'div'
  #   @node.className = 'rdbUI-container'
  #   document.body.appendChild @node

  #   @tether = new Tether
  #     element: @node
  #     target: @props.target
  #     attachment: @props.attachment
  #     targetAttachment: @props.targetAttachment
  #     constraints: [{to: 'window', pin: true, attachment: "together"}]

  #   React.renderComponent @renderComponent(), @node

  # componentDidUpdate: ->
  #   React.renderComponent @renderComponent(), @node

  # componentWillUnmount: ->
  #   React.unmountComponentAtNode @node
  #   document.body.removeChild @node

  render: ->
    div className: 'rdbUI-container-inlet', @props.children

module.exports = DropdownContainer
