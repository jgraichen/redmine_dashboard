React = require 'react'
Tether = require 'tether/tether'

core = require './core'
{span} = require './DOM'

Attachment = core.createComponent 'rui.Attachment',
  getDefaultProps: ->
    attachment: 'top left'
    targetAttachment: 'bottom left'

  componentDidMount: ->
    @node = document.createElement 'div'
    @node.className = 'rui-attachment'
    document.body.appendChild @node

    @handleCloseRequest = (e) =>
      node = e.target
      while node != null
        if node == @node || node == @props.source
          return true

        node = node.parentNode

      if node == null
        @props.onCloseRequest?()

      true

    document.addEventListener 'mousedown', @handleCloseRequest
    document.addEventListener 'focus', @handleCloseRequest, true

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

    document.removeEventListener 'mousedown', @handleCloseRequest
    document.removeEventListener 'focus', @handleCloseRequest

  renderComponent: ->
    @props.children

  render: ->
    span()

Attachment.update = ->
  Tether.position()

module.exports = Attachment
