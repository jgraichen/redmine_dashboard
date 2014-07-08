{Model} = require 'backbone'

class Board extends Model
  validation:
    'name':
      required: true

  initialize: ->
    @url =
      base: "/dashboards/#{@get("id")}"
      configure: "/dashboards/#{@get("id")}/configure"

module.exports = Board
