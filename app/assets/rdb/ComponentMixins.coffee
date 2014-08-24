Rdb = require 'rdb/index'
{span, img} = require 'rui/DOM'

module.exports =
  Spinner:
    getInitialState: ->
      spinner: 0

    getDefaultProps: ->
      spinnerSize: 16

    showSpinner: (promise) ->
      @spinner ||= 0
      @spinner += 1
      @setState spinner: @spinner

      reset = =>
        @spinner -= 1
        @setState spinner: @spinner

      promise.then(reset).catch(reset)
      promise

    renderSpinner: ->
      if @state.spinner > 0
        img src: "#{Rdb.base}images/loading.gif", alt: '', style: {
          width: @props.spinnerSize
          height: @props.spinnerSize
        }
      else
        span style: {
          display: 'inline-block'
          width: @props.spinnerSize
          height: @props.spinnerSize
        }
