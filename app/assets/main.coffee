require './shim/phantomjs-bind'

window.Promise = require 'bluebird'
window.Rdb = require('rdb/index')
