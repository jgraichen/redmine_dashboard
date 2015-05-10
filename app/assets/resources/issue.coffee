{Model, Collection} = require 'exoskeleton'

class Issue extends Model
  # initialize: (opts) ->
    # @board   = opts.board
    # @urlRoot = @collection.url() + '/issues'

class Issue.Collection extends Collection
  model: Issue

  initialize: (opts) ->
    board = opts.board
    query = '?' + ("#{key}=#{value}" for key, value of opts.params).join('&')

    @url   = board.url() + '/issues' + query

module.exports = Issue
