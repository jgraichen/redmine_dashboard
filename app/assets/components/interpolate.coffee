#
React = require 'react'
$ = React.createElement

REGEXP = /\%\((.+?)\)s/

class Interpolate extends React.Component
  render: =>
    component = @props.component || 'span'

    args = @props.children.split(REGEXP).reduce (memo, match, index) =>
      if index % 2 == 0
        if match.length > 0
          memo.push match
      else
        memo.push @props[match]
      memo
    , []

    $ component, @props, args

module.exports = Interpolate
