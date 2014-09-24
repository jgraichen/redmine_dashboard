cx = require 'react/lib/cx'
map = require("react/lib/ReactChildren").map

core = require './core'
{div, ul, li, hr, findParent} = require './DOM'

Menu = core.createComponent 'RUI.Menu',
  render: ->
    cs = 'rui-menu'
    cs += " #{@props.className}" if @props.className?

    @transferPropsTo div className: cs, @props.children

Menu.List = core.createComponent 'RUI.Menu.List',
  render: ->
    cs = 'rui-menu-list'
    cs += " #{@props.className}" if @props.className?

    @transferPropsTo ul className: cs, @props.children

Menu.Item = core.createComponent 'RUI.Menu.Item',
  render: ->
    cs = cx
      'rui-menu-item': true
      'rui-menu-item-active': @props.active

    cs += " #{@props.className}" if @props.className?

    @transferPropsTo li
      className: cs
      @props.children

Menu.Separator = core.createComponent 'rui-menu-separator',
  render: ->
    @transferPropsTo li className: 'rui-menu-separator', hr()

module.exports = Menu
