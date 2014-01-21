# =========================================================
# Redmine Dashboard
#
#= require_self
#= require rdb.ui.menu

# =========================================================
# Redmine Dashboard jQuery Helper

$.fn.isAny = ->
  $(this).length != 0

$.fn.isEmpty = ->
  $(this).length == 0
