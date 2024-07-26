//
const { resolve, join } = require("path");

const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const postcssEnv = require("postcss-preset-env");
const cssnano = require("cssnano");

module.exports = async function (env, argv) {
  const ROOT = resolve(__dirname);
  const mode = argv.mode === "production" ? "production" : "development";

  // Define loaders as separate constants. This eases reading rules as they will
  // only use the predefined loader constant names.

  const css = {
    loader: "css-loader",
    options: {
      sourceMap: true,
    },
  };

  // PostCSS loader for applying autoprefixer rules and minify CSS based on
  // browserlist.
  const postcss = {
    loader: "postcss-loader",
    options: {
      sourceMap: true,
      postcssOptions: {
        plugins: [postcssEnv(), mode === "production" ? cssnano() : null],
      },
    },
  };

  // Transform SASS into CSS.
  const sass = {
    loader: "sass-loader",
    options: {
      sourceMap: true,
    },
  };

  const babel = {
    loader: "babel-loader",
    options: {
      presets: [
        [
          "@babel/preset-env",
          { corejs: 3, loose: true, modules: false, useBuiltIns: "usage" },
        ],
        "@babel/preset-typescript",
      ],
      plugins: [
        ["@babel/plugin-transform-react-jsx", { runtime: "automatic" }],
        ["@babel/plugin-transform-runtime", { useESModules: true }],
      ],
    },
  };

  const config = {
    mode,
    devtool: mode === "production" ? "source-map" : "inline-source-map",

    entry: {
      main: ["./app/assets/main", "./app/assets/main.scss"],
    },

    output: {
      clean: true,
      path: join(__dirname, "assets"),
      publicPath: "/plugin_assets/redmine_dashboard/",
    },

    resolve: {
      extensions: [".tsx", ".ts", ".sass", ".scss", ".css", "..."],
      alias: {
        "react/jsx-runtime.js": "preact/jsx-runtime",
        "react-dom": "preact/compat",
        react: "preact/compat",
      },
    },

    module: {
      rules: [
        {
          test: /\.s[ac]ss$/i,
          use: [MiniCssExtractPlugin.loader, css, postcss, sass],
        },
        {
          test: /\.(m?js|ts)x?$/i,
          exclude: /node_modules\//,
          use: [babel],
        },
      ],
    },

    plugins: [
      // Extract CSS into standalone files instead of bundling it with the JS
      // bundles.
      new MiniCssExtractPlugin(),
    ],

    optimization: {
      // Always do tree shaking to avoid issues in production only and to be
      // able to analyze module usage while in development environment.
      concatenateModules: true,

      // Use deterministic module IDs to avoid changes to *all* bundles just
      // because e.g. the load order changed.
      moduleIds: "deterministic",
    },

    stats: {
      errorDetails: true,
    },

    devServer: {
      static: {
        watch: {
          ignored: /node_modules/,
        },
      },
      allowedHosts: [".localhost", "localhost"],
      headers: { "Access-Control-Allow-Origin": "*" },
      host: "0.0.0.0",
      port: 7001,
      proxy: { "/": "http://localhost:7000" },
    },
  };

  return config;
};
