React = require 'react'

t = require 'counterpart'
$ = React.createElement

ActivityIndicator = require 'molecule/lib/activity-indicator'

Issue = require './resources/issue'
Dashboard = require './components/dashboard'
Configuration = require './components/configuration'
IssueCard = require './components/issue-card'

class Taskboard extends Dashboard
  renderBoard: ->
    $ 'div', className: 'rdb-main-board rdb-taskboard', @renderColumns()

  renderColumns: ->
    @props.board.get('columns').map (column) =>
      $ Taskboard.Column,
        key: column['id']
        board: @props.board
        name: column['name']
        id: column['id']

class Taskboard.Column extends React.Component
  constructor: (props) ->
    super props
    @state = collection: new Issue.Collection board: props.board, params: {column: props.id}

  componentDidMount: ->
    @refs['indicator'].track @state.collection.fetch().then => @forceUpdate()

  render: ->
    $ 'div', className: "rdb-column rdb-column-#{@props.id}", [
      $ 'h3', null, [
        @props.name
        $ ActivityIndicator, ref: 'indicator'
      ]
      $ 'ul', null, @state.collection.map (item) ->
        $ IssueCard, model: item
    ]

# -- configuration

class Taskboard.Configuration extends Configuration
  constructor: (props) ->
    super props

    @panels.push Taskboard.Configuration.Column

class Taskboard.Configuration.Column extends React.Component
  @info:
    name: t 'rdb.configure.columns.nav'
    help: t 'rdb.configure.columns.nav_text'

  render: ->
    $ 'section'

module.exports = Taskboard
