# =========================================================
# Redmine Dashboard

# Library dependencies
#
#= require jquery/jquery
#= require jquery-ui/jquery-ui
#= require underscore/underscore
#= require backbone/backbone
#= require backbone.epoxy/backbone.epoxy
#= require mousetrap/mousetrap

# Application files
#
#= require_self
#= require library/rdb.key
#= require library/rdb.utils
#= require library/rdb.ui.dropdown
#= require library/rdb.ui.fullscreen
#= require rdb.application

window.Rdb =
  ready: (fun) ->
    fun Rdb.$, Rdb._, Rdb.Backbone

  init: (data) ->
    Rdb.application = new Rdb.Application()
    Rdb.application.run(data)

Rdb.jQuery = Rdb.$ = jQuery.noConflict()
Rdb.Backbone   = Backbone.noConflict()
Rdb.Backbone.$ = Rdb.$
Rdb.Underscore = _.noConflict()
