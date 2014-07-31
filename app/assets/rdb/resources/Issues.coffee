_ = require 'underscore'
{Collection} = require 'backbone'

class Issues extends Collection
  initialize: (opts) ->
    board = opts.board
    query = '?' + ("#{key}=#{value}" for key, value of opts.params).join('&')

    @url   = board.url() + '/issues' + query

module.exports = Issues
