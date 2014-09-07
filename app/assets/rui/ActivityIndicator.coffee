classSet = require 'react/lib/cx'

Rdb = require 'rdb/index'
core = require './core'
{span, img} = require 'rui/DOM'

ActivityIndicator = core.createComponent 'rui.ActivityIndicator',
  getInitialState: ->
    spinner: 0

  getDefaultProps: ->
    spinnerSize: 16
    tick: true

  add: ->
    return unless @isMounted()

    @spinner ||= 0
    @spinner += 1
    @setState spinner: @spinner

  remove: (error = false) ->
    return unless @isMounted()

    @spinner -= 1 if @spinner > 0
    @setState spinner: @spinner, error: error

  track: (promise) ->
    @add()

    promise.then(=> @remove()).catch(=> @remove(true))
    promise

  render: ->
    cs = classSet
      'rui-activity-indicator': true
      'rui-visible': @state.spinner > 0
      'rui-hidden': @state.spinner <= 0 && @props.tick && !@state.error

    image = if @state.spinner <= 0 && @props.tick && !@state.error
      "#{Rdb.base}images/true.png"
    else
      "#{Rdb.base}images/loading.gif"

    span
      className: cs,
      style:
        width: @props.spinnerSize
        height: @props.spinnerSize
      [
        img
          src: image
          alt: ''
          style:
            width: @props.spinnerSize
            height: @props.spinnerSize
      ]

module.exports = ActivityIndicator
