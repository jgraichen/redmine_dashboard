core = require 'rui/core'
{div} = require 'rui/DOM'

module.exports = core.createComponent 'rdb.BoardComponent',
  componentDidMount: ->
    @props.board.on 'change', (=> @forceUpdate()), @

  componentWillUnmount: ->
    @props.board.off null, null, @

  boardComponent: ->
    switch @props.board.get 'type'
      when 'taskboard'
        require('./Taskboard')
      else
        undefined

  render: ->
    switch @props.action
      when 'show'
        @transferPropsTo @boardComponent().Main()
      when 'configure'
        @transferPropsTo @boardComponent().Configuration()
      else
        @props.root [ 'UNKNOWN ACTION' ]
