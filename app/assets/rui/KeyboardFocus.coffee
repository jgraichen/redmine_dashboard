KeyboardSupport = require './KeyboardSupport'

module.exports =
  mixins: [KeyboardSupport]

  getInitialState: ->
    focus: false

  getDefaultProps: ->
    onFocus: => @_KeyboardFocus_onFocus()
    onBlur: => @_KeyboardFocus_onBlur()

  _KeyboardFocus_onFocus: (e) ->
    if @state.keyPressed
      @setState focus: true

  _KeyboardFocus_onBlur: (e) ->
    @setState focus: false
