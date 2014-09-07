core = require './core'
Input = require './Input'
{p, span, label} = require './DOM'

Form =
  Input: core.createComponent 'rui.Form.Input',
    getInitialState: ->
      uniqueId: core.uniqueId()

    render: ->
      p className: 'rui-form-p', [
        label htmlFor: @state.uniqueId, @props.label if @props.label?
        span [
          Input
            ref: 'input'
            value: @props.value
          span className: 'rui-form-help', @props.help
        ]
      ]

module.exports = Form
