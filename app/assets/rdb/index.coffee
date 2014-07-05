# Assign redmine's jQuery object to Backbone
require('backbone').$ = window.$

Application = require('./application')

Rdb =
  init: (config, data) ->
    Rdb.app = new Application()
    Rdb.app.run config, data

module.exports = Rdb
