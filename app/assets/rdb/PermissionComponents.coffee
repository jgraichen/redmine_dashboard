t = require 'counterpart'
extend = require 'extend'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Input = require 'rui/Input'
Anchor = require 'rui/Anchor'
Button = require 'rui/Button'
Select = require 'rui/Select'

{table, thead, tbody, tr, th, td, img} = require 'rui/DOM'

Permission = require 'rdb/Permission'

BackboneMixins = require 'rdb/BackboneMixins'
ComponentMixins = require 'rdb/ComponentMixins'

Row = core.createComponent 'rdb.Permission.Row',
  mixins: [
    BackboneMixins.ModelView
    ComponentMixins.Spinner
  ]

  render: ->
    tr [
      td className: 'rdb-name', [
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
      ]
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

  addPermission: ->
    id   = @refs['id'].getDOMNode().value
    role = @refs['role'].getDOMNode().value

    @props.collection.create
      role: role,
      principal:
        type: 'user',
        id: id
    @props.collection.fetch merge: true

  renderPermissionHead: ->
    tr [
      th [
        Input ref: 'id'
      ]
      th [
        Select ref: 'role', [
          Select.Option value: 'read', t 'rdb.permissions.read'
          Select.Option value: 'edit', t 'rdb.permissions.edit'
          Select.Option value: 'admin', t 'rdb.permissions.admin'
        ]
      ]
      th [
        Button
          onClick: (e) => @addPermission()
          'Add'
      ]
      th()
    ]

module.exports =
  Editor: Editor
