React = require 'react'
$ = React.createElement

Component = require 'molecule/lib/component'
Link = require 'molecule/lib/link'

Events = require '../events'
util = require '../util'

class Navigate extends Component
  prepare: (props) =>
    props.onAction = do (original = props.onAction, href = props.href) =>
      (e) =>
        original? e
        Events.trigger 'navigate', href
        e.preventDefault()

    props.href = util.url props.href

  renderComponent: (props) =>
    $ Link, props

module.exports = Navigate
