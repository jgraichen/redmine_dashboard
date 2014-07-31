core = require 'rui/core'
{ul, li} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.IssueList',
  componentDidMount: ->
    @props.issues.on 'change', @update, this
    @props.issues.fetch()

  componentWillUnmount: ->
    @props.issues.off null, null, this

  update: ->
    @forceUpdate()

  render: ->
    ul className: 'rdb-column', @props.issues.map (issue) ->
      li key: issue.get('id'), issue.get('title')
