
Util =
  isUnmodifiedEvent: (e) ->
    !e.altKey && !e.ctrlKey && !e.metaKey && !e.shiftKey

  isPrimaryButton: (e) ->
    e.button == 0

  isPrimaryClick: (e) ->
    Util.isUnmodifiedEvent(e) && Util.isPrimaryButton(e)

  handlePrimaryClick: (e, fn) ->
    if Util.isPrimaryClick(e)
      e.preventDefault()
      fn(e)

module.exports = Util
