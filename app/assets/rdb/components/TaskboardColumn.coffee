core = require 'rui/core'
{div, h3} = require 'rui/DOM'

IssueList = require './IssueList'
IssueCollection = require '../resources/IssueCollection'

module.exports = core.createComponent 'rdb.TaskboardColumn',
  getInitialState: ->
    issues: new IssueCollection board: @props.board, params: {column: @props.id}

  # componentDidMount: ->
  #   @state.issues.on 'change', @update, @

  # componentWillUnmount: ->
  #   @state.issues.off null, null, @

  # update: ->
  #   @forceUpdate()

  render: ->
    div className: "rdb-column rdb-column-#{@props.id}", [
      h3 @props.name
      div [ IssueList issues: @state.issues, className: 'rdb-column' ]
    ]
