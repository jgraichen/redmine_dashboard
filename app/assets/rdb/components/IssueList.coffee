core = require 'rui/core'
{ul, li} = require 'rui/DOM'

IssueCard = require './IssueCard'

module.exports = core.createComponent 'rdb.IssueList',
  componentDidMount: ->
    @props.issues.on 'add remove reset', @update, this
    @props.issues.fetch()

  componentWillUnmount: ->
    @props.issues.off null, null, this

  update: ->
    @forceUpdate()

  render: ->
    @transferPropsTo ul className: "#{@props.className} rdb-issue-list", @props.issues.map (issue) ->
      li key: issue.get('id'), [ IssueCard issue: issue ]
