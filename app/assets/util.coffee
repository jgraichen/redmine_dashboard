#
_uniqueId     = 0;
CONTENT_TYPES = json: /json/

module.exports =

  uniqueId: ->
    _uniqueId += 1;
    "_unq_#{_uniqueId}"

  url: (url, params) ->
    query = ''
    for key, value of params
      query += "&#{encodeURIComponent(key)}=#{encodeURIComponent(value)}"

    if query.length > 0
      query = "?#{query.substring(1)}"

    "#{Rdb.base}#{url}#{query}"

  curl: (method, url, options = {}) ->
    new Promise (resolve, reject) ->
      xhr = new XMLHttpRequest
      xhr.open method, url, true

      data = options.data

      if options.json?
        xhr.setRequestHeader 'Content-Type', 'application/json'
        data = JSON.stringify options.json

      xhr.setRequestHeader 'Accept','application/json'

      csrf = document.getElementsByName('csrf-token')
      if csrf.length > 0
        xhr.setRequestHeader 'X-CSRF-Token', csrf[0].content

      xhr.onload = ->
        try
          ct = xhr.getResponseHeader('Content-Type')
          if CONTENT_TYPES.json.test(ct)
            xhr.responseJSON = JSON.parse xhr.response

          if xhr.status >= 200 && xhr.status < 300
            resolve xhr
          else
            throw new ErroneousResponse xhr
        catch err
          err.xhr = xhr
          reject err

      xhr.onerror = (err) ->
        err.xhr = xhr
        reject err

      xhr.send data
