React = require 'react'
t = require 'counterpart'
$ = React.createElement

ActivityIndicator = require 'molecule/lib/activity-indicator'
AutoComplete = require 'molecule/lib/mixins/auto-complete'
Component = require 'molecule/lib/component'
Select = require 'molecule/lib/select'
Button = require 'molecule/lib/button'
Input = require 'molecule/lib/input'
Icon = require 'molecule/lib/icon'
Link = require 'molecule/lib/link'

Backbone = require './mixins/backbone'
util = require '../util'

class PermissionEditor extends Component
  @include Backbone.Collection

  renderComponent: (props) =>
    $ 'table', className: 'rdb-permission-editor', [
      $ 'thead', null, @renderHead props
      $ 'tbody', null, @renderBody props
    ]

  renderHead: (props) =>
    $ 'tr', null, [
      $ 'th', null, [
        $ Input,
          ref: 'principal'
          size: 'fluid'
          placeholder: t 'rdb.configure.general.access_control_placeholder'
          onSubmit: @addPermission
          mixins: [
            AutoComplete
              query: @queryPrincipal
              render: @renderPrincipal
          ]
      ]
      $ 'th', null, [
        $ Select,
          ref: 'role',
          size: 'fluid',
          items: [
            {value: 'read', text: t 'rdb.permissions.read'}
            {value: 'edit', text: t 'rdb.permissions.edit'}
            {value: 'admin', text: t 'rdb.permissions.admin'}
          ]
          render: (item) => item.text
      ]
      $ 'th', null, [
        $ Button,
          size: 'fluid',
          onAction: @addPermission
          [
            $ Icon, glyph: 'plus'
            t 'rdb.configure.general.access_control_add'
          ]
      ]
      $ 'th', null, [
        $ ActivityIndicator, ref: 'indicator'
      ]
    ]

  queryPrincipal: (value) =>
    url = util.url @props.collection.rel.search, q: value
    util.curl('GET', url).then (xhr) =>
      xhr.responseJSON

  renderPrincipal: (item) =>
    icon = if item['avatar_url']?.length > 0
      $ 'img', className: 'rdb-avatar', src: item['avatar_url']
    else if item['type'] == 'user'
      $ Icon, glyph: 'user', className: 'rdb-avatar'
    else
      $ Icon, glyph: 'users', className: 'rdb-avatar'

    $ 'span', className: 'rdb-permission-complete', [
      icon,
      $ 'strong', null, item['name']
      item['value']
    ]

  renderBody: (props) ->
    $ 'tbody', null, @props.collection.map (item) =>
      $ PermissionEditor.Row, model: item

  addPermission: (e) =>
    e.preventDefault()

    principal = @refs['principal'].getValue()
    role      = @refs['role'].getValue().value

    if principal
      p = new Promise (resolve, reject) =>
        @props.collection.create {role: role, principal: principal},
          success: resolve
          error: reject
          wait: true

      p = p.then =>
        @props.collection.fetch merge: true

      @refs['indicator'].track p
      @refs['principal'].clear()
      @refs['principal'].focus()

class PermissionEditor.Row extends Component
  @include Backbone.Model

  renderComponent: (props) =>
    $ 'tr', null, [
      $ 'td', key: 0, className: 'rdb-name', [
        @renderPermissionSymbol()
        @props.model.getName()
      ]
      $ 'td', key: 1, className: 'rdb-roles', [
        $ Link,
          classList: [
            'active' if @props.model.isRead()
          ]
          onAction: => @props.model.setRead()
          t 'rdb.permissions.read'
        $ Link,
          classList: [
            'active' if @props.model.isEdit()
          ]
          onAction: => @props.model.setEdit()
          t 'rdb.permissions.edit'
        $ Link,
          classList: [
            'active' if @props.model.isAdmin()
          ]
          onAction: => @props.model.setAdmin()
          t 'rdb.permissions.admin'
      ]
      $ 'td', key: 2, className: 'rdb-actions', [
        $ Link,
          href: '#',
          onAction: (e) =>
            e.preventDefault()
            @props.model.destroy()
          t 'rdb.contextual.remove'
      ]
      $ 'td', null,
        $ ActivityIndicator, ref: 'indicator'
    ]

  renderPermissionSymbol: ->
    if @props.model.getAvatarUrl()?
      $ 'img', className: 'rdb-avatar', src: @props.model.getAvatarUrl()
    else
      if @props.model.getType() == 'user'
        $ Icon, glyph: 'user', className: 'rdb-avatar'
      else
        $ Icon, glyph: 'users', className: 'rdb-avatar'

module.exports = PermissionEditor
