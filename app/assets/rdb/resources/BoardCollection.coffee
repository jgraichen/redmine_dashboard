_ = require 'underscore'
{Collection} = require 'backbone'

Board = require './Board'

class BoardCollection extends Collection
  model: Board
  url: '/rdb/api/boards'

module.exports = BoardCollection
