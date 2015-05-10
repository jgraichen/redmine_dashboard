{Model, Collection} = require 'exoskeleton'

Permission = require './permission'
util = require '../util'

class Board extends Model
  urlRoot: 'rdb/api/boards'

  initialize: ->
    @rel =
      show:      "rdb/dashboards/#{@get("id")}"
      configure: "rdb/dashboards/#{@get("id")}/configure"
      create:    "rdb/dashboards/#{@get("id")}/new"

  getName: ->
    @get 'name'

  getPermissions: ->
    @permissions ||= new Permission.Collection @get('permissions'), board: this

class Board.Collection extends Collection
  model: Board
  url: 'rdb/api/boards'

module.exports = Board
