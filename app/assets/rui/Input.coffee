# RdbUI Input Component
extend = require 'extend'
classSet = require 'react/lib/cx'

core = require './core'
util = require './util'
Icon = require './Icon'
KeyboardFocus = require './KeyboardFocus'
{a, span, div, input, textarea, form, label} = require './DOM'

genUniq = do ->
  index = 0
  -> "rui-input-n#{index++}"

Input = core.createComponent 'rui.Input',
  mixins: [KeyboardFocus]

  getDefaultProps: ->
    id: genUniq()

  getInitialState: ->
    value: @props.value

  activate: (e) ->
    return if @state.active

    e?.preventDefault()
    @setState active: true, value: @props.value, =>
      @refs['input'].getDOMNode().focus()

  deactivate: (e) ->
    return unless @state.active

    e?.preventDefault()
    @setState active: false, error: false, value: @props.value

  save: (e) ->
    e?.preventDefault()
    if @props.value != @state.value && @state.active
      @props.onSave? @state.value
        .then =>
          if @isMounted() then @deactivate()
        .catch Input.Error, (err) =>
          if @isMounted()
            @setState active: true, error: err.message, =>
              @refs['input'].getDOMNode().focus()
        .catch (err) =>
          console.warn 'Input received unknown error:', err
          if @isMounted() then @deactivate()
    else
      @deactivate()

  render: ->
    cs = classSet
      'rui-input': true
      'rui-input-active': @state.active
      'rui-input-inactive': !@state.active
      'focus': !@state.focus

    form
      className: cs,
      onSubmit: (e) => @save(e)
    , [
      @renderLabel()
      @renderInput()
      @renderAction()
      @renderError()
    ]

  renderLabel: ->
    if @props.label
      label className: 'rui-input-label', htmlFor: @props.id, @props.label

  renderInput: ->
    cs = classSet
      'rui-input-preview': !@state.active
      'focus': @state.focus

    component = if @props.multiline then textarea else input

    @transferPropsTo component
      id: @props.id
      ref: 'input'
      value: @state.value
      readOnly: !@state.active
      className: cs
      onChange: (e) =>
        @setState value: e.target.value
      onBlur: (e) =>
        @_KeyboardFocus_onBlur(e)
        e.preventDefault()
        setTimeout (=> @save()), 100 # Otherwise will be triggered before
                                     # onClick of cancel button
      onClick: (e) =>
        if util.isPrimaryClick(e) then @activate(e)
      onKeyPress: (e) =>
        if e.keyCode == 13 then @activate(e)
      onFocus: (e) =>
        @_KeyboardFocus_onFocus(e)
        if @state.keyPressed then @activate(e)

  renderAction: ->
    span className: 'rui-input-action', do =>
      if @state.active || @state.error
        a
          key: 'cancel'
          ref: 'cancel'
          onClick: (e) =>
            if util.isPrimaryClick(e) then @deactivate(e)
          Icon glyph: 'circle-x'
      else
        a
          key: 'edit'
          onClick: (e) =>
            if util.isPrimaryClick(e) then @activate(e)
          Icon glyph: 'pencil'

  renderError: ->
    if @state.error then span className: 'rui-input-error', @state.error

class Input.Error extends Error
  constructor: (@message) ->
    @name = 'rui.Input.Error'

module.exports = Input
