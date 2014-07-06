React = require 'react'
core = require 'rdbUI/core'

# Wrap all React.DOM functions into the helper above.
DOM = do ->
  object = {}
  for name, fn of React.DOM
    object[name] = core.wrapComponentConstructor fn
  object

module.exports = DOM
