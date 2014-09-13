_ = require 'lodash'
React = require 'react'
extend = require 'extend'
Exoskeleton = require 'exoskeleton'

CONTENT_TYPES =
  json: /json/

class window.ErroneousResponse extends Error
  constructor: (@xhr) ->
    super "Erroneous XHR response: #{@xhr.status}"

Exoskeleton.sync = (method, model, options) ->
  url = _.result model, 'url'
  if !url?
    return reject new Error 'A "url" property must be defined.'

  url = Rdb.url url

  type = {
    'read': 'GET'
    'patch': 'PATCH'
    'create': 'POST'
    'update': 'PUT'
    'delete': 'DELETE'
  }[method]

  options.json = if model && (method == 'create' || method == 'update' || method == 'patch')
    options.attrs || model.toJSON options

  Rdb.curl(type, url, options)
    .then (xhr) ->
      options.success xhr.responseJSON
      xhr
    .catch (err) ->
      options.error err.xhr
      throw err

App = require 'rdb/application'
Board = require 'rdb/Board'

counterpart = require 'counterpart'
counterpart.registerTranslations('en', require('app/locales/en.yml')['en'])
counterpart.registerTranslations('de', require('app/locales/de.yml')['de'])
counterpart.registerTranslations('zh', require('app/locales/zh.yml')['zh'])

util = require 'rui/util'

Rdb =
  curl: (method, url, options = {}) ->
    new Promise (resolve, reject) ->
      xhr = new XMLHttpRequest
      xhr.open method, url, true

      data = options.data

      if options.json?
        xhr.setRequestHeader 'Content-Type', 'application/json'
        data = JSON.stringify options.json

      xhr.setRequestHeader 'Accept','application/json'

      csrf = document.getElementsByName('csrf-token')
      if csrf.length > 0
        xhr.setRequestHeader 'X-CSRF-Token', csrf[0].content

      xhr.onload = ->
        try
          ct = xhr.getResponseHeader('Content-Type')
          if CONTENT_TYPES.json.test(ct)
            xhr.responseJSON = JSON.parse xhr.response

          if xhr.status >= 200 && xhr.status < 300
            resolve xhr
          else
            throw new ErroneousResponse xhr
        catch err
          err.xhr = xhr
          reject err

      xhr.onerror = (err) ->
        err.xhr = xhr
        reject err

      xhr.send data

  navigate: (route, opts = {}) ->
    opts = extend trigger: true, opts

    Rdb.router.navigate route, opts

  nav: (path, opts = {}) ->
    (e) ->
      util.handlePrimary e, (e) =>
        Rdb.router.navigate path, extend(trigger: true, opts)

  url: (path, params = {}) ->
    query = ''
    for key, value of params
      query += "&#{encodeURIComponent(key)}=#{encodeURIComponent(value)}"

    if query.length > 0
      query = "?#{query.substring(1)}"

    "#{Rdb.base}/rdb/#{path}#{query}"

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
