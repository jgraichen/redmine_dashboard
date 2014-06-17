# =========================================================
# Redmine Dashboard Script Utilities
#

Array::first ?= (n) ->
  if n? then @[0...(Math.max 0, n)] else @[0]

Array::last ?= (n) ->
  if n? then @[(Math.max @length - n, 0)...] else @[@length - 1]

Rdb.ready ($) ->
  $.fn.isAny = ->
    $(this).length > 0

  $.fn.isEmpty = ->
    $(this).length == 0
