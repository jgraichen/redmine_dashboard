# =========================================================
# Redmine Dashboard
#
#= require jquery
#= require jquery.ui
#= require underscore
#= require backbone
#= require mousetrap
#
#= require_self
#= require rdb.utils
#= require rdb.key
#= require rdb.ui.dropdown

# =========================================================
# Redmine Dashboard jQuery Helper

window.Rdb =
  ready: (fun) ->
    fun Rdb.$, Rdb._, Rdb.Backbone

Rdb.jQuery = Rdb.$ = jQuery.noConflict()
Rdb.Backbone   = Backbone.noConflict()
Rdb.Backbone.$ = Rdb.$
Rdb.Underscore = _.noConflict()

Rdb.$.fn.isAny = ->
  $(this).length != 0

Rdb.$.fn.isEmpty = ->
  $(this).length == 0
