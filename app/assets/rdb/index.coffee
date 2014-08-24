_ = require 'lodash'
React = require 'react'
extend = require 'extend'
Promise = require 'bluebird'
Exoskeleton = require 'exoskeleton'

CONTENT_TYPES =
  json: /json/

Exoskeleton.sync = (method, model, options) ->
  new Promise (resolve, reject) ->
    url = _.result model, 'url'
    url || throw Error 'A "url" property must be defined.'

    type = {
      'read': 'GET'
      'patch': 'PATCH'
      'create': 'POST'
      'update': 'PUT'
      'delete': 'DELETE'
    }[method]

    xhr = new XMLHttpRequest
    xhr.open type, url, true

    data = ''
    json = undefined

    if model && (method == 'create' || method == 'update')
      xhr.setRequestHeader 'Content-Type', 'application/json'
      json = options.attrs || model.toJSON options
      data = JSON.stringify json

    xhr.setRequestHeader 'Accept','application/jsonx'

    csrf = document.getElementsByName('csrf-token')
    if csrf.length > 0
      xhr.setRequestHeader 'X-CSRF-Token', csrf[0].content

    xhr.onload = ->
      try
        ct = xhr.getResponseHeader('Content-Type')
        if CONTENT_TYPES.json.test(ct)
          xhr.responseJSON = JSON.parse xhr.response

        if xhr.status == 200
          options.success xhr.responseJSON
          resolve xhr
        else
          options.error xhr
          reject xhr
      catch err
        reject err

    if process.env.NODE_ENV == 'development'
      console.log "XHR> #{type} #{url}", json || data

    xhr.onerror = reject
    xhr.send data

App = require 'rdb/application'
Board = require 'rdb/Board'

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
    Rdb.base   = config['base']
    Rdb.events = extend({}, Exoskeleton.Events)

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

    Exoskeleton.history.start
      # root: "/dashboards/#{Rdb.board.get("id")}"
      pushState: true

module.exports = Rdb
