React = require 'react'

core = require './core'
# Wrap all React.DOM functions into the helper above.
DOM = do ->
  object = {}
  for name, fn of React.DOM
    object[name] = core.wrapComponentConstructor fn
  object

DOM.searchUp = (node, fn) ->
  while !fn node && node != null
    node = node.parentNode
  node

module.exports = DOM
