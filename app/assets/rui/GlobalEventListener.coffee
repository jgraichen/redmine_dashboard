listeners = {}
functions = {}

GlobalEventListener =
  addGlobalEventListener: (name, fn) ->
    if !(name in listeners)
      functions[name] = []
      listeners[name] = (e) ->
        for fn in functions[name]
          if fn(e) == false
            e.preventDefault()
            e.stopPropagation()
            return

      document.addEventListener name, listeners[name]

    functions[name].push fn

  removeGlobalEventListener: (name, fn) ->
    return unless name in functions

    functions[name].remove fn

module.exports = GlobalEventListener
