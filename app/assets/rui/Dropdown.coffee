React = require 'react'
Tether = require 'tether/tether'
classSet = require 'react/lib/cx'

core = require './core'
{div, span} = require './DOM'

Dropdown = core.createComponent 'rui.Dropdown',
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
      constraints: [{to: '#redmine-dashboard', pin: true, attachment: "together"}]

    React.renderComponent @renderComponent(), @node

  componentDidUpdate: ->
    React.renderComponent @renderComponent(), @node

  componentWillUnmount: ->
    React.unmountComponentAtNode @node

    @tether.destroy()
    document.body.removeChild @node

  renderComponent: ->
    if @props.visible
      @node.className = 'rui-container rui-visible'
    else
      @node.className = 'rui-container'

    div className: 'rui-container-inlet', @props.children

  render: ->
    span()

module.exports = Dropdown
