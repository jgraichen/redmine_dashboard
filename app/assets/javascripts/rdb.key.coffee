# =========================================================
# Redmine Dashboard Key Utilities
#

Rdb.key =
  scopes: {}
  stack: []
  current: null

  # Define a new key bindings scope.
  # First give a name and second a function accepting
  # `Bindings` as an argument to register actual key traps.
  define: (scope, func) ->

    # Create new bindings.
    bindings = new Rdb.key.Bindings scope, func

    # Save bindings in scope list with given name.
    Rdb.key.scopes[scope] = bindings

  # Push a binding scope to stack.
  push: (scope, args) ->

    # Search for bindings with given name.
    scopeBindings = Rdb.key.scopes[scope]

    if scopeBindings
      # Unbind previous bindings.
      @stack.last()?.unbind()

      # Push to stack if found.
      @stack.push scopeBindings

      # Bind new top bindings.
      scopeBindings.bind args

    else

      # Warn if scope not found.
      console.warn "Rdb.key scope bindings not found for: #{scope}"

  # Pop binding scope from stack.
  pop: ->
    # Pop current bindings.
    prevBindings = @stack.pop()

    # Unbind current bindings.
    prevBindings?.unbind()

    # Bind previous bindings.
    @stack.last()?.bind()

# A set of key bindings like a scope.
class Rdb.key.Bindings
  constructor: (name, func) ->
    @name = name
    @keys = {}
    @func = func

  # Register key trap
  on: (keys, callback, unbindCallback) =>

    # Convert given keys to Array. If it isn't an Array it
    # will be converted to an Array with one element.
    keys = [keys] unless keys instanceof Array

    # Iterate all keys and add them to local list of
    # registered key callbacks.
    for key in keys
      @keys[key] = [callback, unbindCallback]

  # Bind registered keys using Mousetrap.
  bind: (args) ->
    @unbind()

    @func this, args

    for key, cbs of @keys
      Mousetrap.bind key, cbs[0]

  # Unbind registered keys.
  unbind: ->
    for key, cbs of @keys
      Mousetrap.unbind key
      cbs[1]?()

    delete @keys
    @keys = {}
