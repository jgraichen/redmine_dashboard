React = require 'react'
Tether = require 'vendor/tether'

DropdownPositionMixing =
  getDefaultProps: ->
    attachment: 'top left'
    targetAttachment: 'bottom left'

  componentDidMount: ->
    @_tether = new Tether
      element: @getDOMNode()
      target: @props.target
      attachment: @props.attachment
      targetAttachment: @props.targetAttachment
      constraints: [{to: 'window', pin: true, attachment: "together"}]
      optimizations:
        moveElement: false

module.exports = DropdownPositionMixing
