React = require 'react'
$ = React.createElement
t = require 'counterpart'

ActivityIndicator = require 'molecule/lib/mixins/activity-indicator'
Component = require 'molecule/lib/component'
Input = require 'molecule/lib/input'
Link = require 'molecule/lib/link'
Icon = require 'molecule/lib/icon'

PermissionEditor = require './permission-editor'
Translate = require './translate'
Navigate = require './navigate'
Observer = require './mixins/observer'
Events = require '../events'
util = require '../util'

class Configuration extends Component
  @include Observer, prop: 'board', on: 'change'

  constructor: (props) ->
    super props

    @panels = [Configuration.Common]
    @state  = currentIndex: 0

  render: ->
    @props.wrapper [
      $ 'div', className: 'contextual', [
        $ Navigate,
          href: @props.board.rel.show
          title: t 'rdb.contextual.back'
          [
            $ Icon, glyph: 'arrow-circle-o-left'
            t 'rdb.contextual.back'
          ]
      ]
      $ Translate,
        component: 'h2'
        link: $ Navigate,
          href: @props.board.rel.show
          @props.board.get 'name'
        'rdb.configure.title'
      $ 'section', className: 'rdb-main rdb-configuration', [
        $ 'nav', null, [
          $ 'h4', null, t 'rdb.configure.nav_title'
          $ 'ul', null, @renderPanelItems()
        ]
        @renderPanel()
      ]
    ]

  renderPanelItems: ->
    @renderPanelItem panel, index for panel, index in @panels

  renderPanelItem: (panel, index) ->
    content = []
    content.push $ 'span', null, panel.info.name

    if panel.info.help?
      content.push $ 'span', className: 'rdb-help', panel.info.help

    $ 'li', null, [
      $ Link,
        active: @state.currentIndex == index
        onAction: (e) =>
          e.preventDefault()
          @setState currentIndex: index
        content
    ]

  renderPanel: ->
    if @panels[@state.currentIndex]?
      $ @panels[@state.currentIndex], board: @props.board
    else
      $ 'section'

class Configuration.Common extends Component
  @info:
    name: t 'rdb.configure.general.nav'
    help: t 'rdb.configure.general.nav_text'

  constructor: (props) ->
    super props

    @nameID = util.uniqueId()

  renderComponent: (props) =>
    $ 'section', null, [
      $ 'h3', null,
        t 'rdb.configure.general.title'
      $ 'p', null,
        t 'rdb.configure.general.description'
      $ 'section', null, [
        $ 'h4', null,
          t 'rdb.configure.general.general'
        $ 'div', className: 'rdb-form-input', [
          $ 'label', htmlFor: @nameID,
            t 'rdb.configure.general.dashboard_name'
          $ 'div', null, [
            $ Input,
              id: @nameID
              size: 'default'
              defaultValue: @props.board.getName()
              submitOnBlur: true
              onSubmit: (value) =>
                @props.board.save {'name': value}, wait: true, patch: true
              onError: (msg) =>
                @setState error: msg
              mixins: [ ActivityIndicator() ]
            $ 'span', className: 'rdb-form-error',
              @state.error
            $ 'span', className: 'rdb-form-help',
              t 'rdb.configure.general.dashboard_name_text'
          ]
        ]
      ]
      $ 'section', null, [
        $ 'h4', null, t 'rdb.configure.general.access_control'
        $ PermissionEditor,
          board: @props.board
          collection: @props.board.getPermissions()
      ]
    ]

module.exports = Configuration
