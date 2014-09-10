React = require 'react'
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
  nspec = extend spec, displayName: name
  fn    = wrapComponentConstructor React.createClass nspec
  fn

module.exports =
  wrapComponentConstructor: wrapComponentConstructor
  createComponent: createComponent
