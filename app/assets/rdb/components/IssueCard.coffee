core = require 'rui/core'
{div, header, section, a, p} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.IssueCard',
  componentDidMount: ->
    @props.issue.on 'change', @update, this

  componentWillUnmount: ->
    @props.issue.off null, null, this

  update: ->
    @forceUpdate()

  render: ->
    div className: 'rdb-issue', [
      div className: 'rdb-issue-inlet', [
        header [
          a [ @props.issue.get 'name' ]
        ]
        section [
          p [ @props.issue.get 'subject' ]
        ]
      ]
    ]
