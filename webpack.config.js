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
  new webpack.IgnorePlugin(new RegExp("^(jquery)$"))
]

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
    fallback: path.join(__dirname, "node_modules"),
    extensions: ['', '.js', '.coffee', '.sass'],
    alias: {
      // Use single global react
      'react': path.dirname(require.resolve('react'))
    }
  },
  resolveLoader: {
    fallback: path.join(__dirname, "node_modules")
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
