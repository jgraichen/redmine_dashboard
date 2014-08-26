require './shim/phantomjs-bind'

unless window.Promise?
  window.Promise = require 'bluebird'

window.Rdb = require('rdb/index')
