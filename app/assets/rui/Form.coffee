core = require './core'
Input = require './Input'
{p, span, label} = require './DOM'

ActivityIndicator = require './ActivityIndicator'

Form =
  Input: core.createComponent 'rui.Form.Input',
    getInitialState: ->
      uniqueId: core.uniqueId()

    render: ->
      p className: 'rui-form-p', [
        label htmlFor: @state.uniqueId, @props.label if @props.label?
        span [
          @transferPropsTo Input
            onError: (err) =>
              @setState error: err
          span className: 'rui-form-error', @state.error if @state.error?
          span className: 'rui-form-help', @props.help
        ]
      ]

module.exports = Form
