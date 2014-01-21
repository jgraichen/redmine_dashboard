# =========================================================
# Redmine Dashboard
#
#= require jquery
#= require jquery.ui
#= require mousetrap
#
#= require_self
#= require rdb.ui.menu

# =========================================================
# Redmine Dashboard jQuery Helper

window.Rdb =
  ready: (fun) ->
    Rdb.$ ->
      Rdb.scope fun

  scope: (fun) ->
    fun Rdb.$

Rdb.jQuery = Rdb.$ = jQuery.noConflict()

Rdb.scope ($) ->
  $.fn.isAny = ->
    $(this).length != 0

  $.fn.isEmpty = ->
    $(this).length == 0
