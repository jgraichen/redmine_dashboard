_ = require 'underscore'
React = require 'react'
{Router, history} = require 'backbone'

Board = require('./resources/board').Board

BoardComponent = require './components/board'
ConfigComponent = require './components/configuration'

class Application extends Router
  routes:
    'dashboards/:id/configure': 'configureBoard'
    'dashboards/:id': 'showBoard'

  root: _.once -> document.getElementById "content"

  configureBoard: (id) ->
    @show ConfigComponent board: @board

  showBoard: (id) ->
    @show BoardComponent board: @board

  show: (component) ->
    React.unmountComponentAtNode @root()
    React.renderComponent component, @root()

  goTo: (event, url) =>
    if !event.altKey && !event.ctrlKey && !event.metaKey && !event.shiftKey
      event.preventDefault()
      @navigate url, trigger: true

  run: (config, data) =>
    @board = new Board data
    history.start pushState: true

module.exports = Application
