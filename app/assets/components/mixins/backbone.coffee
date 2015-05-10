#
module.exports =
  Model: ->
    componentDidMount: ->
      if @props.model?
        @props.model.on 'change', (=> @forceUpdate()), @

    componentWillUnmount: ->
      if @props.model?
        @props.model.off null, null, @

  Collection: ->
    componentDidMount: ->
      if @props.collection?
        @props.collection.on 'add remove reset', (=> @forceUpdate()), @

    componentWillUnmount: ->
      if @props.collection?
        @props.collection.off null, null, @
