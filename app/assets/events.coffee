#
Exoskeleton = require 'exoskeleton'
assign = require 'object-assign'

Events = assign {}, Exoskeleton.Events,
  handle:
    navigate: (e) ->
      e.preventDefault()
      Events.trigger 'navigate', @href

  Mixin: ->
    componentDidMount: ->
      if @events?
        for fname, events of @events
          Events.on events, @[fname], @

    componentWillUnmount: ->
      Events.off null, null, @

module.exports = Events
