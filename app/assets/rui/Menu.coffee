map = require("react/lib/ReactChildren").map

core = require './core'
{div, ul, li, hr, findParent} = require './DOM'

Menu = core.createComponent 'RUI.Menu',
  render: ->
    @transferPropsTo div className: 'rui-menu', @props.children

Menu.List = core.createComponent 'RUI.Menu.List',
  render: ->
    @transferPropsTo ul className: 'rui-menu-list', @props.children

Menu.Item = core.createComponent 'RUI.Menu.Item',
  render: ->
    cs = cx
      'rui-menu-item': true
      'rui-menu-item-active': @props.active

    @transferPropsTo li
      className: cs
      @props.children

Menu.Separator = core.createComponent 'rui-menu-separator',
  render: ->
    @transferPropsTo hr()

module.exports = Menu
