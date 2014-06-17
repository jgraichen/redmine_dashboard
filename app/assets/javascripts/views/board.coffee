#= require templates/board

Rdb.ready ($, _, Backbone) ->
  class Rdb.Views.Board extends Backbone.View
    template: JST['templates/board']

    initialize: (board) =>
      @board = board
      # @$el.html @template board: @board

