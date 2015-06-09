var ExtractTextPlugin = require("extract-text-webpack-plugin");

var webpack      = require('webpack');
var autoprefixer = require('autoprefixer-core');
var csswring     = require('csswring');
var path         = require('path');

var sass = 'sass' +
  '?indentedSyntax=sass' +
  '&includePaths[]=' + (path.resolve(__dirname, "./node_modules"));

var plugins = [
  new ExtractTextPlugin("[name].css", { allChunks: true }),
  new webpack.EnvironmentPlugin(['NODE_ENV']),
  new webpack.IgnorePlugin(new RegExp("^(jquery)$")),
  new webpack.optimize.OccurenceOrderPlugin(),
  new webpack.optimize.UglifyJsPlugin({compress: {warnings: false}})
]

if(process.env.NODE_ENV === 'development') {
  plugins.push(new webpack.SourceMapDevToolPlugin());
}

module.exports = {
  target: 'web',
  entry: [
    './app/assets/main.coffee',
    './app/assets/main.sass'
  ],
  output: {
    path: "assets",
    filename: "[name].js",
    chunkFilename: "[name].[id].[chunkhash].js"
  },
  resolve: {
    extensions: ['', '.js', '.coffee', '.sass']
  },
  module: {
    loaders: [
      { test: /exoskeleton.js$/, loader: 'imports?define=>false' },
      { test: /\.coffee$/, loader: 'coffee' },
      { test: /\.sass$/, loader: ExtractTextPlugin.extract('css!postcss!' + sass) },
      { test: /\.yml$/, loader: 'json!yaml' },
      { test: /\.(ttf|eot|svg|woff2?)(\?.*)?$/, loader: "file?name=[name]-[hash].[ext]" },
    ]
  },
  postcss: [
    autoprefixer,
    csswring
  ],
  plugins: plugins
};
