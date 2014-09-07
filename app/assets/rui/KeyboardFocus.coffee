KeyboardSupport = require './KeyboardSupport'

module.exports =
  mixins: [KeyboardSupport]

  getInitialState: ->
    focus: false

  componentDidMount: ->
    @_KeyboardFocus_focus = =>
      if @state.keyPressed
        @setState focus: true
        if @getDOMNode().classList?
          @getDOMNode().classList.add 'focus' unless @getDOMNode().classList.contains 'focus'
    @_KeyboardFocus_blur = =>
      @setState focus: false
      if @getDOMNode().classList?
        @getDOMNode().classList.remove 'focus'

    @getDOMNode().addEventListener 'focus', @_KeyboardFocus_focus
    @getDOMNode().addEventListener 'blur', @_KeyboardFocus_blur

  componentWillUnmount: ->
    @getDOMNode().removeEventListener 'focus', @_KeyboardFocus_focus
    @getDOMNode().removeEventListener 'blur', @_KeyboardFocus_blur
