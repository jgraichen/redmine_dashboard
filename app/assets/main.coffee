require './shim/phantomjs-bind'

window.Promise = require 'bluebird'

if process.env.NODE_ENV == 'development'
  Promise.longStackTraces()

window.Rdb = require 'index'
