React = require 'react'

LayeredComponent =
  componentDidMount: ->
    @_target = document.createElement 'div'
    document.body.appendChild @_target

    @_renderLayer()

  componentDidUpdate: ->
    @_renderLayer()

  componentWillUnmount: ->
    @_unrenderLayer()
    document.body.removeChild @_target

  _renderLayer: ->
    layer = @renderLayer()
    if React.isValidComponent layer
      React.renderComponent layer, @_target
    else
      @_unrenderLayer()

  _unrenderLayer: ->
    React.unmountComponentAtNode @_target

  _getLayerNode: ->
    @_target.getDOMNode()

module.exports = LayeredComponent
