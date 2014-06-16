# =========================================================
# Redmine Dashboard Key Utilities
#

Rdb.key =
  bind: (key, fn) ->
    @callbacks = {} unless @callbacks?

    if @callbacks[key]?
      @callbacks[key].push fn
    else
      @callbacks[key] = [fn]
      Mousetrap.bind key, =>
        for fn in @callbacks[key]
          break if fn.apply @, arguments
