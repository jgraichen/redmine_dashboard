# RdbUI Input Component
extend = require 'extend'
classSet = require 'react/lib/cx'

core = require './core'
util = require './util'
Icon = require './Icon'
KeyboardFocus = require './KeyboardFocus'
{a, span, div, input, textarea, form} = require './DOM'

Input = core.createComponent 'rui.Input',
  mixins: [KeyboardFocus]

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
          @deactivate()
        .catch Input.Error, (err) =>
          @setState active: true, error: err.message, =>
            @refs['input'].getDOMNode().focus()
        .catch (err) =>
          console.warn 'Input received unknown error:', err
          @deactivate()
    else
      @deactivate()

  render: ->
    props = extend {}, @props

    # Only needed for initial state
    delete props.value

    cs = classSet
      'rui-input': true
      'rui-input-active': @state.active
      'rui-input-inactive': !@state.active
      'focus': !@state.focus

    ccs = classSet
      'rui-input-preview': !@state.active
      'focus': @state.focus

    #
    component = if @props.multiline then textarea else input

    form
      className: cs,
      onSubmit: (e) => @save(e)
    , [
      component
        ref: 'input'
        value: @state.value
        readOnly: !@state.active
        className: ccs
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
      do =>
        if @state.error then span className: 'rui-input-error', @state.error
    ]

class Input.Error extends Error
  constructor: (@message) ->
    @name = 'rui.Input.Error'

module.exports = Input
