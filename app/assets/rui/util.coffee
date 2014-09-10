
Util =
  isUnmodifiedEvent: (e) ->
    !e.altKey && !e.ctrlKey && !e.metaKey && !e.shiftKey

  isPrimaryButton: (e) ->
    e.button == 0

  isPrimary: (e) ->
    Util.isUnmodifiedEvent(e) && Util.isPrimaryButton(e)

  handlePrimary: (e, fn) ->
    if Util.isPrimary(e)
      e.preventDefault()
      fn(e)
      false

  onPrimary: (fn) ->
    (e) -> fn(e) if Util.isPrimaryClick(e)

module.exports = Util
