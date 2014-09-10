t = require 'counterpart'
extend = require 'extend'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Input = require 'rui/Input'
Anchor = require 'rui/Anchor'
Avatar = require 'rui/Avatar'
Button = require 'rui/Button'
Search = require 'rui/Search'
Select = require 'rui/Select'
ActivityIndicator = require 'rui/ActivityIndicator'

{table, thead, tbody, tr, th, td, img, span} = require 'rui/DOM'

Permission = require 'rdb/Permission'

BackboneMixins = require 'rdb/BackboneMixins'
ComponentMixins = require 'rdb/ComponentMixins'

Row = core.createComponent 'rdb.Permission.Row',
  mixins: [BackboneMixins.ModelView]

  render: ->
    tr [
      td className: 'rdb-name', [
        @renderPermissionSymbol()
        @props.model.getName()
      ]
      td className: 'rdb-roles', [
        Anchor
          className: if @props.model.isRead() then 'rdb-active'
          onPrimary: =>
            @refs['indicator'].track @props.model.setRead()
            false
          t 'rdb.permissions.read'
        Anchor
          className: if @props.model.isEdit() then 'rdb-active'
          onPrimary: =>
            @refs['indicator'].track @props.model.setEdit()
            false
          t 'rdb.permissions.edit'
        Anchor
          className: if @props.model.isAdmin() then 'rdb-active'
          onPrimary: =>
            @refs['indicator'].track @props.model.setAdmin()
            false
          t 'rdb.permissions.admin'
      ]
      td className: 'rdb-actions', [
        Anchor
          icon: 'trash-o',
          onPrimary: =>
            @props.onDelete @props.model.destroy()
            false
          t('rdb.contextual.remove')
      ]
      td [
        ActivityIndicator ref: 'indicator'
      ]
    ]

  renderPermissionSymbol: ->
    if @props.model.getAvatarUrl()?
      Avatar src: @props.model.getAvatarUrl()
    else
      switch @props.model.getType()
        when 'user'
          Icon glyph: 'user', className: 'rui-avatar'
        else
          Icon glyph: 'users', className: 'rui-avatar'


Editor = core.createComponent 'rdb.Permission.Editor',
  mixins: [BackboneMixins.CollectionView]

  render: ->
    table className: 'rdb-permissions', [
      thead [ @renderPermissionHead() ]
      tbody @renderCollectionItems (item) =>
        Row
          model: item
          onDelete: (promise) => @refs['indicator'].track promise
    ]

  addPermission: ->
    principal = @refs['principal'].value()
    role      = @refs['role'].value().value

    p = new Promise (resolve, reject) =>
      @props.collection.create {role: role, principal: principal},
        success: resolve
        error: reject

    p = p.then =>
      @props.collection.fetch merge: true

    @refs['indicator'].track p

    @refs['principal'].clear()
    @refs['principal'].focus()

  renderPrincipal: (principal) ->
    components = []
    if principal['avatar_url']?.length > 0
      components.push Avatar src: principal['avatar_url']
    else
      switch principal['type']
        when 'user'
          components.push Icon glyph: 'user', className: 'rui-avatar'
        else
          components.push Icon glyph: 'users', className: 'rui-avatar'

    components.push principal['name']
    span components

  renderPermissionHead: ->
    tr [
      th [
        Search
          ref: 'principal'
          placeholder: t('rdb.configure.general.access_control_placeholder')
          query: (q) =>
            Rdb.curl('GET', Rdb.url(@props.collection.url + '/search', q: q))
              .then (xhr) => xhr.responseJSON
          renderItem: @renderPrincipal
          renderValue: @renderPrincipal
          onSubmit: => @addPermission()
      ]
      th [
        Select
          ref: 'role'
          items: [
            {value: 'read', text: t('rdb.permissions.read')}
            {value: 'edit', text: t('rdb.permissions.edit')}
            {value: 'admin', text: t('rdb.permissions.admin')}
          ]
          renderItem: (item) ->
            item['text']
          renderValue: (item) ->
            item['text']
      ]
      th [
        Button
          onClick: (e) =>
            @addPermission()
            false
          icon: 'plus'
          t('rdb.configure.general.access_control_add')
      ]
      th [
        ActivityIndicator ref: 'indicator'
      ]
    ]

module.exports =
  Editor: Editor
