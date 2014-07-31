{Model} = require 'backbone'

class Issue extends Model
  initialize: (opts) ->
    @board   = opts.board
    @urlRoot = @board.url() + '/issues'

module.exports = Issue
