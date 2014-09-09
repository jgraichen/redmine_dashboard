{Model, Collection} = require 'exoskeleton'

Permission = require 'rdb/Permission'

class Board extends Model
  urlRoot: 'api/boards'

  initialize: ->
    @urls =
      root: "/rdb/dashboards/#{@get("id")}"
      configure: "/rdb/dashboards/#{@get("id")}/configure"
      create: "/rdb/dashboards/#{@get("id")}/new"

  getName: ->
    @get 'name'

  getPermissions: ->
    @permissions ||= new Permission.Collection @get('permissions'), board: this

class Board.Collection extends Collection
  model: Board
  url: 'api/boards'

module.exports = Board
