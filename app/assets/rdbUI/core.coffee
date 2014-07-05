React  = require 'react'
extend = require 'extend'

# A utility function to wrap a React.DOM or React.createClass
# function to allow omitting the leading object (hash) when
# only children are needed, e.g.:
#
# DOM.h1 [ DOM.span, DOM.span ]
#
# instead of:
#
# DOM.h1 {}, [ DOM.span {}, DOM.span {} ]
#
wrapComponentConstructor = (ctor) ->
  (args...) ->
    args.unshift {} unless typeof args[0] is 'object' && !Array.isArray(args[0])
    ctor.apply this, args

# Utility function to create named react component.
createComponent = (name, spec) ->
  wrapComponentConstructor React.createClass extend(spec, displayName: name)

module.exports =
  # Wrap all React.DOM functions into the helper above.
  DOM: do ->
    object = {}
    for name, fn of React.DOM
      object[name] = wrapComponentConstructor fn
    object

  # An observer is a wrapping component that updates on
  # an event on given observable object e.g. a Backbone model.
  #
  Observer: createComponent 'RdbUI.Observer',
    componentDidMount: ->
      @props.watch.on @props.event, @update

    componentWillUnmount: ->
      @props.watch.off null, @update

    update: ->
      @forceUpdate()

    render: ->
      @props.render()

  createComponent: createComponent
