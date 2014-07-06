core = require 'rdbUI/core'

# An observer is a wrapping component that updates on
# an event on given observable object e.g. a Backbone model.
#
Observer = core.createComponent 'RdbUI.Observer',
  componentDidMount: ->
    @props.watch.on @props.event, @update

  componentWillUnmount: ->
    @props.watch.off null, @update

  update: ->
    @forceUpdate()

  render: ->
    @props.render()

module.exports = Observer
