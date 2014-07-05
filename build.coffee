coffeeify    =  require 'coffeeify'
browserify   =  require 'browserify'
fs           =  require 'fs'
path         =  require 'path'
bundlePath   =  path.join __dirname, 'assets', 'redmine-dashboard.js'

browserify()
  .transform(coffeeify)
  .require(require.resolve('./src/main'), entry: true)
  .bundle({ debug: true })
  .pipe(fs.createWriteStream bundlePath)
