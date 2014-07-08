React = require 'react'
Tether = require 'vendor/tether'

core = require './core'
{div, span} = require './DOM'

DropdownContainer = core.createComponent 'rui.DropdownContainer',
  getDefaultProps: ->
    attachment: 'top left'
    targetAttachment: 'bottom left'

  componentDidMount: ->
    @node = document.createElement 'div'
    @node.className = 'rui-container'
    document.body.appendChild @node

    @tether = new Tether
      element: @node
      target: @props.target
      attachment: @props.attachment
      targetAttachment: @props.targetAttachment
      classPrefix: 'rui'
      constraints: [{to: 'window', pin: true, attachment: "together"}]

    React.renderComponent @renderComponent(), @node

  componentDidUpdate: ->
    React.renderComponent @renderComponent(), @node

  componentWillUnmount: ->
    React.unmountComponentAtNode @node

    @tether.destroy()
    document.body.removeChild @node

  renderComponent: ->
    div className: 'rui-container-inlet', @props.children

  render: ->
    span()

module.exports = DropdownContainer
