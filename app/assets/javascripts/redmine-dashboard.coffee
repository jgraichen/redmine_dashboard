# =========================================================
# Redmine Dashboard
#
#= require jquery
#= require jquery.ui
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
    fun Rdb.$

Rdb.jQuery = Rdb.$ = jQuery.noConflict()

Rdb.$.fn.isAny = ->
  $(this).length != 0

Rdb.$.fn.isEmpty = ->
  $(this).length == 0
