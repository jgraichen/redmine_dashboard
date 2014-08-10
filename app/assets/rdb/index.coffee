# Assign jQuery object to Backbone
$ = require 'jquery'
Promise = require 'bluebird'
require('backbone').$ = $

# Wrap all jQuery XHRs into real promises
ajax = $.ajax
$.ajax = -> Promise.resolve ajax arguments...

# CSRF token handling taken from rails/jquery-ujs
$.ajaxPrefilter (options, originalOptions, xhr) ->
  if !options.crossDomain
    token = $('meta[name="csrf-token"]').attr 'content'
    xhr.setRequestHeader 'X-CSRF-Token', token

App = require './application'
React = require 'react'
Board = require './resources/Board'
extend = require 'extend'
Backbone = require 'backbone'

counterpart = require 'counterpart'
counterpart.registerTranslations('en', require('app/locales/en.yml')['en'])
counterpart.registerTranslations('de', require('app/locales/de.yml')['de'])
counterpart.registerTranslations('zh', require('app/locales/zh.yml')['zh'])

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
    Rdb.board.on 'all', (e, args...) ->
      Rdb.events.trigger "board:#{e}", args...

    component = App.Component
      board: Rdb.board

    React.renderComponent component, Rdb.root

    Backbone.history.start
      # root: "/dashboards/#{Rdb.board.get("id")}"
      pushState: true

module.exports = Rdb
