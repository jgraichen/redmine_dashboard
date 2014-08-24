module.exports =
  componentDidMount: ->
    if @events
      for events, fn of @events
        Rdb.events.on events, @[fn], @

  componentWillUnmount: ->
    Rdb.events.off null, null, @

  trigger: ->
    Rdb.events.trigger arguments...
