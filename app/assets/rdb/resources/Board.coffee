{Model} = require 'backbone'

class Board extends Model
  validation:
    'name':
      required: true

  urlRoot: '/rdb/api/dashboards'

  initialize: ->
    @urls =
      root: "/rdb/dashboards/#{@get("id")}"
      configure: "/rdb/dashboards/#{@get("id")}/configure"

module.exports = Board
