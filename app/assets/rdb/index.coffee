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

util = require 'rui/util'

Rdb =
  navigate: (route, opts = {}) ->
    opts = extend trigger: true, opts

    Rdb.router.navigate route, opts

  nav: (path, opts = {}) ->
    (e) ->
      util.handlePrimaryClick e, (e) =>
        Rdb.router.navigate path, extend(trigger: true, opts)

  init: (config, data) ->
    counterpart.setLocale config['locale']

    Rdb.root   = document.getElementById 'main'
    Rdb.events = extend({}, Backbone.Events)

    if process.env.NODE_ENV == 'development'
      Rdb.events.on 'all', ->
        console.warn 'DEBUG>', arguments...

    Rdb.router = new App.Router()
    Rdb.router.on 'all', ->
      Rdb.events.trigger arguments...

    if data
      board = new Board data

    Rdb.app = App.Component board: board

    React.renderComponent Rdb.app, Rdb.root

    Backbone.history.start
      # root: "/dashboards/#{Rdb.board.get("id")}"
      pushState: true

module.exports = Rdb
