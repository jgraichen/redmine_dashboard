map = require("react/lib/ReactChildren").map

core = require './core'
{ul, li, hr} = require './DOM'

Menu = core.createComponent 'rui.Menu',
  render: ->
    @transferPropsTo ul className: 'rui-menu', [
      map @props.children, (child) =>
        li className: 'rui-menu-item', child
    ]

Menu.Separator = core.createComponent 'rui-menu-separator',
  render: ->
    @transferPropsTo hr()

module.exports = Menu
