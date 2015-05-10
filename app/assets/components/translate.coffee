assign = require 'object-assign'
React = require 'react'

$ = React.createElement
t = require 'counterpart'

Interpolate = require './interpolate'

class Translate extends React.Component
  render: =>
    props = assign {}, @props

    for key, val of props
      if React.isValidElement(val)
        props[key] = "%(#{key})s"

    $ Interpolate, @props, t @props.children, props

module.exports = Translate
