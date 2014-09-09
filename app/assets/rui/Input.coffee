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

{div, span, input, textarea, ul, li} = require './DOM'

Input = core.createComponent 'rui.Input',
  mixins: [KeyboardFocus]

  getInitialState: ->
    value: @props.value
    error: false

  getDefaultProps: ->
    type: 'text'

  submit: ->
    return unless @props.onSubmit

    if @props.value != @state.value
      clearTimeout @timeout if @timeout?

      promise = @props.onSubmit @state.value
      if promise?
        promise
          .then =>
            @setState error: false, => @props.onError?(false)
          .catch (err) =>
            if err.name? && err.name == 'Input.Error'
              @setState error: true, =>
                @refs['input'].getDOMNode().focus()
                @props.onError?(err.message)

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

  setValue: (value) ->
    @setState value: value

  render: ->
    cs = classSet
      'rui-input-element': true
      'rui-input-error': @state.error

    components = []
    components.push @transferPropsTo input
      ref: 'input'
      value: @state.value
      className: cs
      onChange: (e) =>
        @change e.target.value
        @props.onChange?(e)

        if @props.extensions?
          ex.onChange?(e.target.value, @) for ex in @props.extensions

      onBlur: (e) =>
        @submit()
        @props.onBlur?(e)

        if @props.extensions?
          ex.onBlur?(e, @) for ex in @props.extensions

      onFocus: (e) =>
        @props.onFocus?(e)

        if @props.extensions?
          ex.onFocus?(e, @) for ex in @props.extensions

    if @props.extensions?
      components.push ex for ex in @props.extensions

    components.push ActivityIndicator ref: 'indicator', tick: @props.tick

    div className: 'rui-input', components

class Input.Error extends Error
  constructor: (@code, @field) ->
    @name = 'Input.Error'
    @message = t("rdb.errors.#{@field}.#{@code}", fallback: t("rdb.errors.#{@code}"))

Input.Autocomplete = core.createComponent 'rui.Input.Autocomplete',
  getInitialState: ->
    visible: false, enabled: false, items: []

  onChange: (value) ->
    promise = @props.onChange value

    if promise
      promise.then (items) =>
        @setState items: items, visible: true
    else
      @setState visible: false

  onFocus: (e) ->
    @setState enabled: true

  onBlur: (e, input) ->
    @setState enabled: false, visible: false, items: []
    input.setValue ''

  render: ->
    cs = classSet
      'rui-input-autocomplete': true
      'rui-visible': @state.visible

    div className: cs, [
      ul @state.items.map (item) => li [ @props.onRender(item) ]
    ]

module.exports = Input
