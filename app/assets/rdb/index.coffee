# Assign redmine's jQuery object to Backbone
require('backbone').$ = window.$

App = require './application'
React = require 'react'
Board = require './resources/board'
extend = require 'extend'
Backbone = require 'backbone'

counterpart = require 'counterpart'
counterpart.registerTranslations('en', require('app/locales/en.yml')['en'])
counterpart.registerTranslations('de', require('app/locales/de.yml')['de'])

Rdb =
  init: (config, data) ->
    counterpart.setLocale config['locale']

    Rdb.root   = document.getElementById 'content'
    Rdb.events = extend({}, Backbone.Events)

    if process.env.NODE_ENV == 'development'
      Rdb.events.on 'all', ->
        console.warn 'DEBUG>', arguments...

    Rdb.router = new App.Router()
    Rdb.router.on 'all', ->
      Rdb.events.trigger arguments...
    Rdb.events.on 'navigate', (path, opts = {}) ->
      opts = extend trigger: true, opts
      Rdb.router.navigate path, opts

    Rdb.board = new Board data

    component = App.Component
      board: Rdb.board

    React.renderComponent component, Rdb.root

    Backbone.history.start
      root: "/dashboards/#{Rdb.board.get("id")}"
      pushState: true

module.exports = Rdb
