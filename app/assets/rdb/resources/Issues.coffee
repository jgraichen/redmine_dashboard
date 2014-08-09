_ = require 'underscore'
{Collection} = require 'backbone'

Issue = require './Issue'

class Issues extends Collection
  model: Issue

  initialize: (opts) ->
    board = opts.board
    query = '?' + ("#{key}=#{value}" for key, value of opts.params).join('&')

    @url   = board.url() + '/issues' + query

module.exports = Issues
