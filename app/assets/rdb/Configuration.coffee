t = require 'counterpart'

core = require 'rui/core'
util = require 'rui/util'
Icon = require 'rui/Icon'
Input = require 'rui/Input'
Button = require 'rui/Button'
Observer = require 'rui/Observer'
Translate = require 'rui/Translate'
Navigation = require 'rui/Navigation'

{div, section, header, h1, h2, h3, a, p, label, span} = require 'rui/DOM'

Rdb = require 'rdb/index'
GeneralConfiguration = require 'rdb/GeneralConfiguration'

module.exports =
  renderCommonConfig: ->
    div
      name: t('rdb.configure.general.nav')
      help: t('rdb.configure.general.nav_text')
      GeneralConfiguration board: @props.board

  render: ->
    backToBoard = (e) =>
      util.handlePrimaryClick e, (e) =>
        Rdb.navigate @props.board.urls.root

    @props.root [
      div className: 'contextual', [
        a
          href: @props.board.urls.root
          title: t 'rdb.contextual.back'
          'aria-label': t 'rdb.contextual.back'
          onClick: Rdb.nav @props.board.urls.root
          [
            Icon glyph: 'arrow-circle-o-left'
            t 'rdb.contextual.back'
          ]
      ]

      Translate
        key: 'rdb.configure.title'
        component: h2
        link: a
          href: @props.board.urls.root
          onClick: backToBoard
          @props.board.get 'name'

      section className: 'rdb-main', [
        Navigation id: 'cfg', name: t('rdb.configure.nav_title'), do =>
          panels = []
          panels.push @renderCommonConfig()
          for panel in @renderConfig()
            panels.push panel

          panels
      ]
    ]
