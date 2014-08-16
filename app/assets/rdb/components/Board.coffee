core = require 'rui/core'
{div} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.Board',
  componentDidMount: ->
    @props.board.on 'change', (=> @forceUpdate()), @

  componentWillUnmount: ->
    @props.board.off null, null, @

  component: ->
    switch @props.board.get("type")
      when 'taskboard'
        require('./Taskboard')
      else
        undefined

  render: ->
    switch @props.action
      when 'show'
        @transferPropsTo @component().Main()
      when 'configure'
        @transferPropsTo @component().Configuration()
      else
        div ['UNKNOWN ACTION']
