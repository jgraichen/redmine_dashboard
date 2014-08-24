module.exports =
  CollectionView:
    componentDidMount: ->
      if @props.collection?
        @props.collection.on 'add remove reset', (=> @forceUpdate()), @

    componentWillUnmount: ->
      if @props.collection?
        @props.collection.off null, null, @

    renderCollectionItems: (factory) ->
      if @props.collection?
        @props.collection.map (item) ->
          factory item
      else
        []

  ModelView:
    componentDidMount: ->
      if @props.model?
        @props.model.on 'change', (=> @forceUpdate()), @

    componentWillUnmount: ->
      if @props.model?
        @props.model.off null, null, @
