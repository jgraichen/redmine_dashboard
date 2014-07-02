Rdb.ready ($, _, Backbone) ->
  class Rdb.Views.BoardConfiguration extends Backbone.Epoxy.View
    events:
      "input.rdb-js-name": "updateName"

    initialize: (options) ->
      @model = options["board"]

      $.ajax Rdb.board.configureUrl,
        success: (html, status, xhr) =>
          this.render html
        error: (xhr, status, err) =>
          console.log 'ERR', xhr, status, err

    render: (html) ->
      this.$el.html html
      this.applyBindings()

