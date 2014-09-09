core = require './core'
Input = require './Input'
{p, div, span, label} = require './DOM'

ActivityIndicator = require './ActivityIndicator'

Form =
  Input: core.createComponent 'rui.Form.Input',
    getInitialState: ->
      uniqueId: core.uniqueId()

    render: ->
      div className: 'rui-form-container', [
        label htmlFor: @state.uniqueId, @props.label
        div [
          @transferPropsTo Input
            id: @state.uniqueId
            onError: (err) =>
              @setState error: err
          span className: 'rui-form-error', @state.error
          span className: 'rui-form-help', @props.help
        ]
      ]

module.exports = Form
