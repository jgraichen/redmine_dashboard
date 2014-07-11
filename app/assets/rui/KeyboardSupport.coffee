require 'mousetrap'

core = require './core'

module.exports =
  componentDidMount: ->
    @_keyUpCallback = =>
      @setState keyPressed: false
    @_keyDownCallback = =>
      @setState keyPressed: true

    document.addEventListener 'keyup', @_keyUpCallback
    document.addEventListener 'keydown', @_keyDownCallback

    if @keyEvents
      @_boundKeyEvents = []
      for fname, keys of @keyEvents
        @_boundKeyEvents.push keys
        Mousetrap.bind keys, @[fname]

  componentWillUnmount: ->
    document.removeEventListener 'keyup', @_keyUpCallback
    document.removeEventListener 'keydown', @_keyDownCallback

    if @_boundKeyEvents
      for keys in @_boundKeyEvents
        Mousetrap.unbind keys
