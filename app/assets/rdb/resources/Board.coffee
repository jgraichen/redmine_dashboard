{Model} = require 'backbone'

class Board extends Model
  validation:
    'name':
      required: true

  urlRoot: '/dashboards'

  initialize: ->
    @urls =
      root: "/dashboards/#{@get("id")}"
      configure: "/dashboards/#{@get("id")}/configure"

module.exports = Board
