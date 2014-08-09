core = require 'rui/core'
{ul, li} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.IssueList',
  componentDidMount: ->
    @props.issues.on 'add remove reset', @update, this
    @props.issues.fetch()

  componentWillUnmount: ->
    @props.issues.off null, null, this

  update: ->
    @forceUpdate()

  render: ->
    @transferPropsTo ul @props.issues.map (issue) ->
      li key: issue.get('id'), issue.get('subject')
