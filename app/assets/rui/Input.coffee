# RdbUI Input Component
t = require 'counterpart'
extend = require 'extend'
classSet = require 'react/lib/cx'

core = require './core'
util = require './util'
Icon = require './Icon'
Translate = require './Translate'
KeyboardFocus = require './KeyboardFocus'
ActivityIndicator = require './ActivityIndicator'

{span, input, textarea} = require './DOM'

Input = core.createComponent 'rui.Input',
  mixins: [KeyboardFocus]

  getInitialState: ->
    value: @props.value
    error: false

  submit: ->
    return unless @props.onSubmit

    if @props.value != @state.value
      clearTimeout @timeout if @timeout?

      promise = @props.onSubmit @state.value
        .catch (err) =>
          if err.name? && err.name == 'Input.Error'
            @setState error: true, =>
              @refs['input'].getDOMNode().focus()
              @props.onError?(err.message)
          throw err
        .then =>
          @setState error: false, => @props.onError?(false)

      @refs['indicator'].track promise
    else
      @setState error: false, => @props.onError?(false)

  change: (value) ->
    @setState value: value
    if @props.autosubmit
      clearTimeout @timeout if @timeout?
      @timeout = setTimeout (=> @submit()), @props.autosubmit

  value: ->
    @state.value

  render: ->
    cs = classSet
      'rui-input-element': true
      'rui-input-error': @state.error

    span className: 'rui-input', [
      @transferPropsTo input
        ref: 'input'
        value: @state.value
        className: cs
        onChange: (e) => @change e.target.value
        onBlur: (e) => @submit()

      ActivityIndicator ref: 'indicator', tick: @props.tick
    ]

class Input.Error extends Error
  constructor: (@code, @field) ->
    @name = 'Input.Error'
    @message = t("rdb.errors.#{@field}.#{@code}", fallback: t("rdb.errors.#{@code}"))

module.exports = Input
