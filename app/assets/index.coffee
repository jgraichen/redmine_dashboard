#
Exoskeleton = require 'exoskeleton'
assign = require 'object-assign'
React = require 'react'
util = require './util'
t = require 'counterpart'
$ = React.createElement

class window.ErroneousResponse extends Error
  constructor: (@xhr) ->
    super "Erroneous XHR response: #{@xhr.status}"

    if @xhr.responseJSON
      for field, code of @xhr.responseJSON['errors']
        @message = t "rdb.errors.#{field}.#{code}", fallback: t "rdb.errors.#{code}"

Exoskeleton.sync = (method, model, options) ->
  if typeof model.url == 'function'
    url = model.url()
  else
    url = model.url

  if !url?
    return reject new Error 'A "url" property must be defined.'

  url = "#{Rdb.base}/#{url}"

  type = {
    'read': 'GET'
    'patch': 'PATCH'
    'create': 'POST'
    'update': 'PUT'
    'delete': 'DELETE'
  }[method]

  options.json = if model && (method == 'create' || method == 'update' || method == 'patch')
    options.attrs || model.toJSON options

  util.curl(type, url, options)
    .then (xhr) ->
      options.success xhr.responseJSON
      xhr
    .catch (err) ->
      options.error err.xhr
      throw err

Board = require './resources/board'
Events = require './events'
Application = require './application'

counterpart = require 'counterpart'
counterpart.registerTranslations('en', require('app/locales/en.yml')['en'])
counterpart.registerTranslations('de', require('app/locales/de.yml')['de'])
counterpart.registerTranslations('zh', require('app/locales/zh.yml')['zh'])

Rdb =
  init: (config, data) ->
    counterpart.setLocale config['locale']
    Rdb.base = config['base']

    board  = if data then new Board(data) else undefined

    root   = document.getElementById 'main'
    router = new Application.Router()

    if 'development' == process.env.NODE_ENV
      Events.on 'all', -> console.log 'DEBUG>', arguments

    app = $ Application, board: board
    React.render app, root

    Exoskeleton.history.start base: Rdb.base, pushState: true

module.exports = Rdb
