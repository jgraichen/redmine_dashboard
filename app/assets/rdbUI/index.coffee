core = require('./core')

module.exports =
  DOM: core.DOM
  createComponent: core.createComponent

  Observer: core.Observer
  Button: require('./button').Button
  ButtonGroup: require('./button').ButtonGroup
  Icon: require('./icon').Icon
  Navigation: require('./navigation').Navigation
  NavigationPane: require('./navigation').NavigationPane
