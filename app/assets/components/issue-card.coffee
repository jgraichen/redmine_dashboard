React = require 'react'
$ = React.createElement

Component = require 'molecule/lib/component'

class IsssueCard extends Component
  componentDidMount: ->
    @props.model.on 'change', (=> @forceUpdate()), @

  componentWillUnmount: ->
    @props.model.off null, null, @

  render: ->
    $ 'div', className: 'rdb-issue', [
      $ 'div', className: 'rdb-issue-inlet', [
        $ 'header', null, [
          $ 'a', null, [ @props.model.get 'name' ]
        ]
        $ 'section', null, [
          $ 'p', null, [ @props.model.get 'subject' ]
        ]
      ]
    ]

module.exports = IsssueCard
