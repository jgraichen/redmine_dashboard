#
module.exports = (opts) ->
  componentDidMount: ->
    if @props[opts.prop]?
      @props[opts.prop].on opts.on, (=> @forceUpdate()), @

  componentWillUnmount: ->
    if @props[opts.prop]?
      @props[opts.prop].off null, null, @
