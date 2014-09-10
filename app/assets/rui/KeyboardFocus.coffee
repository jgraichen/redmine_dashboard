KeyboardSupport = require './KeyboardSupport'

module.exports =
  mixins: [KeyboardSupport]

  getInitialState: ->
    __focused: false

  isFocused: ->
    @state.__focused

  componentDidMount: ->
    @_KeyboardFocus_focus = =>
      @setState __focused: true if @state.keyPressed
    @_KeyboardFocus_blur = =>
      @setState __focused: false

    @getDOMNode().addEventListener 'focus', @_KeyboardFocus_focus
    @getDOMNode().addEventListener 'blur', @_KeyboardFocus_blur

  componentWillUnmount: ->
    @getDOMNode().removeEventListener 'focus', @_KeyboardFocus_focus
    @getDOMNode().removeEventListener 'blur', @_KeyboardFocus_blur
