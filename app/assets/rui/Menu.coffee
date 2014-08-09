map = require("react/lib/ReactChildren").map

core = require './core'
{ul, li} = require './DOM'

Menu = core.createComponent 'rui.Menu',
  render: ->
    @transferPropsTo ul className: 'rui-menu', [
      map @props.children, (child) =>
        li className: 'rui-menu-item', child
    ]

module.exports = Menu
