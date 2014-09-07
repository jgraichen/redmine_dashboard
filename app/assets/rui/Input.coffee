# RdbUI Input Component
extend = require 'extend'
classSet = require 'react/lib/cx'

core = require './core'
util = require './util'
Icon = require './Icon'
Translate = require './Translate'
KeyboardFocus = require './KeyboardFocus'
{input, textarea} = require './DOM'

Input = core.createComponent 'rui.Input',
  mixins: [KeyboardFocus]

  getInitialState: ->
    value: @props.value

  save: (e) ->
    e?.preventDefault()
    if @props.value != @state.value && @state.active
      @props.onSave? @state.value
        .catch Input.Error, (err) =>
          if @isMounted()
            @setState error: err.message, =>
              @refs['input'].getDOMNode().focus()
        .catch (err) =>
          if @isMounted() then @setState value: @props.value
          throw err
    else
      @deactivate()

  render: ->
    cs = classSet
      'rui-input': true
      'rui-multiline': @props.multiline

    component = if @props.multiline then textarea else input
    @transferPropsTo component
      ref: 'input'
      value: @state.value
      className: cs
      onChange: (e) =>
        @setState value: e.target.value


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
    span key: 'a', className: 'rui-input-action', do =>
      if @state.active || @state.error
        a
          key: 'cancel'
          ref: 'cancel'
          title: Translate.t('rui.input.cancel')
          'aria-label': Translate.t('rui.input.cancel')
          onClick: (e) =>
            if util.isPrimaryClick(e) then @deactivate(e)
          Icon glyph: 'times'
      else
        a
          key: 'edit'
          title: Translate.t('rui.input.edit')
          'aria-label': Translate.t('rui.input.edit')
          onClick: (e) =>
            if util.isPrimaryClick(e) then @activate(e)
          Icon glyph: 'pencil'

  renderError: ->
    if @state.error
      span key: 'e', className: 'rui-input-error', @state.error

  renderHelp: ->
    if @props.help
      span key: 'h', className: 'rui-input-help', @props.help

class Input.Error extends Error
  constructor: (@message) ->
    @name = 'rui.Input.Error'

module.exports = Input
