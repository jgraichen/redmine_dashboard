t = require 'counterpart'
extend = require 'extend'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Input = require 'rui/Input'
Anchor = require 'rui/Anchor'

{table, thead, tbody, tr, th, td, img} = require 'rui/DOM'

BackboneMixins = require 'rdb/BackboneMixins'
ComponentMixins = require 'rdb/ComponentMixins'

Row = core.createComponent 'rdb.Permission.Row',
  mixins: [
    BackboneMixins.ModelView
    ComponentMixins.Spinner
  ]

  render: ->
    tr [
      td className: "rdb-name", [
        @renderPermissionSymbol()
        @props.model.getName()
      ]
      td className: 'rdb-roles', [
        Anchor
          className: if @props.model.isRead() then 'rdb-active'
          onPrimary: => @showSpinner @props.model.setRead()
          t 'rdb.permissions.read'
        Anchor
          className: if @props.model.isEdit() then 'rdb-active'
          onPrimary: => @showSpinner @props.model.setEdit()
          t 'rdb.permissions.edit'
        Anchor
          className: if @props.model.isAdmin() then 'rdb-active'
          onPrimary: => @showSpinner @props.model.setAdmin()
          t 'rdb.permissions.admin'
      ],
      td className: 'rdb-actions', [
        Anchor
          icon: 'trash-o',
          onPrimary: => @props.model.destroy()
          t('rdb.contextual.remove')
      ]
      td [
        @renderSpinner()
      ]
    ]

  renderPermissionSymbol: ->
    if @props.model.getAvatarUrl()?
      img src: @props.model.getAvatarUrl(), className: 'rdb-avatar'
    else
      switch @props.model.getType()
        when 'user'
          Icon glyph: 'user'
        else
          Icon glyph: 'users'


Editor = core.createComponent 'rdb.Permission.Editor',
  mixins: [BackboneMixins.CollectionView]

  getDefaultProps: ->
    collection: @props.board.getPermissions()

  componentDidMount: ->
    # @props.collection.fetch()

  render: ->
    table className: 'rdb-permissions', [
      thead [ @renderPermissionHead() ]
      tbody @renderCollectionItems (item) -> Row model: item
    ]

  renderPermissionHead: ->
    tr [
      th()
      th()
      th()
      th()
    ]

module.exports =
  Editor: Editor
