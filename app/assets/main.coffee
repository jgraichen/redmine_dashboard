require './shim/phantomjs-bind'

unless window.Promise?
  window.Promise = require 'bluebird'

  if process.env.NODE_ENV == 'development'
    Promise.longStackTraces()

window.Rdb = require('rdb/index')
