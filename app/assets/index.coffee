#
Exoskeleton = require 'exoskeleton'
assign = require 'object-assign'
React = require 'react'
ReactDOM = require 'react-dom'
util = require './util'
t = require 'counterpart'
$ = React.createElement

_trErr = (name, field, error) ->
  for key in ["#{name}.#{field}.#{error}", "#{name}.#{error}", error]
    message = t key, scope: 'rdb.errors', fallback: 1

    return message if message != 1
  error

class window.ErroneousResponse extends Error
  constructor: (@xhr) ->
    super "Erroneous XHR response: #{@xhr.status}"

    if @xhr.responseJSON['errors']
      @errors = @xhr.responseJSON['errors']

    @messages = {}
    for field, errors of @errors
      @messages[field] = errors.map (o) -> o

  setResource: (name) ->
    for field, errors of @errors
      @messages[field] = _trErr(name, field, error) for error in errors

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
      err.setResource? model.modelKey
      throw err

Board = require './resources/board'
Events = require './events'
Application = require './application'

counterpart = require 'counterpart'
counterpart.registerTranslations('en', require('../locales/en.yml')['en'])
counterpart.registerTranslations('de', require('../locales/de.yml')['de'])
counterpart.registerTranslations('zh', require('../locales/zh.yml')['zh'])

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
    ReactDOM.render app, root

    Exoskeleton.history.start base: Rdb.base, pushState: true

module.exports = Rdb
