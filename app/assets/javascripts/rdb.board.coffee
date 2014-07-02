Rdb.ready ($, _, Backbone) ->
  class Rdb.Board extends Backbone.Model
    validation:
      'name':
        required: true

    initialize: (data) ->
      @id   = data['id']
      @name = data['name']

      @configureUrl = "/dashboards/#{@id}/configure.html"
