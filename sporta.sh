#!/bin/bash


# set up variables
port=5000     # change this
wpport=5001   # change this too
host=35.171.87.95
backend=git@bitbucket.org:clubsporta/sportabackend.git
frontend=git@bitbucket.org:clubsporta/sportafrontend.git


# configure back-end
mkdir ~/sporta
cd ./sporta
git clone $backend
cd ./sportabackend
git checkout development
cat > ./src/sportsunited/settings/credentials.py << EOF
SECRET_KEY = ')02%i4qu#+mybx3xvv(8j)=j_mbr-&*+a47_z)$0x7t)_q^am_'

SPORTA_DBUSER = 'sportauser'
SPORTA_DBPASSWORD = 'sportapassword'

MYEMAIL = 'sporta@clubsporta.com'
MYEMAILPASSWORD = 'sportaadmin'

SPORTADEV_DBUSER='sportadevuser'
SPORTADEV_DBPASSWORD='sportadevpassword'
EOF
virtualenv env
source ./env/bin/activate
pip3 install -r ./src/requirements.txt
#python manage.py createsuperuser


# configure front-end
cd ~/sporta
git clone $frontend
cd ./sportafrontend
git checkout develop
cat > ./src/config.js << EOF
require('babel-polyfill');

const environment = {
  development: {
    isProduction: false
  },
  production: {
    isProduction: true
  }
}[process.env.NODE_ENV || 'development'];

module.exports = Object.assign({
  host: process.env.HOST || 'localhost',
  // port: process.env.PORT || 8080,
  port: $port,
  // apiHost: process.env.APIHOST || 'https://52.90.93.190/',
  apiHost: process.env.APIHOST || 'http://localhost:8050/',
  apiPort: process.env.APIPORT,
  app: {
    title: 'Sporta',
    description: 'Connecting athletes and leagues to one simple platform.',
    head: {
      titleTemplate: 'Sporta | %s',
      meta: [
        { name: 'description', content: 'Sporta: Finding teams and leagues made easier' },
        { charset: 'utf-8' },
        { property: 'og:site_name', content: '' },
        { property: 'og:image', content: '' },
        { property: 'og:locale', content: 'en_US' },
        { property: 'og:title', content: '' },
        { property: 'og:description', content: '' },
        { property: 'og:card', content: 'summary' },
        { property: 'og:site', content: '@enzoames' },
        { property: 'og:creator', content: '@enzoames' },
        { property: 'og:image:width', content: '200' },
        { property: 'og:image:height', content: '200' }
      ]
    }
  },

}, environment);

EOF
cat > ./webpack/dev.config.js << EOF
require('babel-polyfill');

// Webpack config for development
var fs = require('fs');
var path = require('path');
var webpack = require('webpack');
var assetsPath = path.resolve(__dirname, '../static/dist');
var host = (process.env.HOST || 'localhost');
// var port = (+process.env.PORT + 1) || 7001;
var port = $wpport;
var helpers = require('./helpers');

// https://github.com/halt-hammerzeit/webpack-isomorphic-tools
var WebpackIsomorphicToolsPlugin = require('webpack-isomorphic-tools/plugin');
var webpackIsomorphicToolsPlugin = new WebpackIsomorphicToolsPlugin(require('./webpack-isomorphic-tools'));

var babelrc = fs.readFileSync('./.babelrc');
var babelrcObject = {};

try {
  babelrcObject = JSON.parse(babelrc);
} catch (err) {
  console.error('==>     ERROR: Error parsing your .babelrc.');
  console.error(err);
}

var babelrcObjectDevelopment = babelrcObject.env && babelrcObject.env.development || {};

// merge global and dev-only plugins
var combinedPlugins = babelrcObject.plugins || [];
combinedPlugins = combinedPlugins.concat(babelrcObjectDevelopment.plugins);

var babelLoaderQuery = Object.assign({}, babelrcObjectDevelopment, babelrcObject, { plugins: combinedPlugins });
delete babelLoaderQuery.env;

var validDLLs = helpers.isValidDLLs(['vendor'], assetsPath);
if (process.env.WEBPACK_DLLS === '1' && !validDLLs) {
  process.env.WEBPACK_DLLS = '0';
  console.warn('webpack dlls disabled');
}

var webpackConfig = module.exports = {
  devtool: 'inline-source-map',
  context: path.resolve(__dirname, '..'),
  entry: {
    'main': [
      'webpack-hot-middleware/client?path=http://' + host + ':' + port + '/__webpack_hmr',
      'react-hot-loader/patch',
      'bootstrap-sass!./src/theme/bootstrap.config.js',
      'font-awesome-webpack!./src/theme/font-awesome.config.js',
      './src/client.js'
    ]
  },
  output: {
    path: assetsPath,
    filename: '[name]-[hash].js',
    chunkFilename: '[name]-[chunkhash].js',
    publicPath: 'http://' + host + ':' + port + '/dist/'
  },
  module: {
    loaders: [
      helpers.createSourceLoader({
        happy: { id: 'jsx' },
        test: /\.jsx?$/,
        loaders: ['react-hot-loader/webpack', 'babel?' + JSON.stringify(babelLoaderQuery), 'eslint-loader'],
      }),
      helpers.createSourceLoader({
        happy: { id: 'json' },
        test: /\.json$/,
        loader: 'json-loader',
      }),
      helpers.createSourceLoader({
        happy: { id: 'less' },
        test: /\.less$/,
        loader: 'style!css?modules&importLoaders=2&sourceMap&localIdentName=[local]___[hash:base64:5]!autoprefixer?browsers=last 2 version!less?outputStyle=expanded&sourceMap',
        //test: /\.less$/,
        //loader: 'style!css?importLoaders=2&sourceMap!autoprefixer?browsers=last 2 version!less?outputStyle=expanded&sourceMap',
      }),
      helpers.createSourceLoader({
        happy: { id: 'sass' },
        test: /\.scss$/,
        loader: 'style!css?modules&importLoaders=2&sourceMap&localIdentName=[local]___[hash:base64:5]!autoprefixer?browsers=last 2 version!sass?outputStyle=expanded&sourceMap',
        //test: /\.scss$/,
        //loader: 'style!css?importLoaders=2&sourceMap!autoprefixer?browsers=last 2 version!sass?outputStyle=expanded&sourceMap',
      }),
      { test: /\.css$/, loader: 'style-loader!css-loader'},
      { test: /\.woff2?(\?v=\d+\.\d+\.\d+)?$/, loader: "url?limit=10000&mimetype=application/font-woff" },
      { test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/, loader: "url?limit=10000&mimetype=application/octet-stream" },
      { test: /\.eot(\?v=\d+\.\d+\.\d+)?$/, loader: "file" },
      { test: /\.svg(\?v=\d+\.\d+\.\d+)?$/, loader: "url?limit=10000&mimetype=image/svg+xml" },
      { test: webpackIsomorphicToolsPlugin.regular_expression('images'), loader: 'url-loader?limit=10240' }
    ]
  },
  progress: true,
  resolve: {
    modulesDirectories: [
      'src',
      'node_modules'
    ],
    extensions: ['', '.json', '.js', '.jsx']
  },
  plugins: [
    // hot reload
    new webpack.HotModuleReplacementPlugin(),
    new webpack.IgnorePlugin(/webpack-stats\.json$/),
    new webpack.DefinePlugin({
      __CLIENT__: true,
      __SERVER__: false,
      __DEVELOPMENT__: true,
      __DEVTOOLS__: true,  // <-------- DISABLE redux-devtools HERE
      __DLLS__: process.env.WEBPACK_DLLS === '1'
    }),
    webpackIsomorphicToolsPlugin.development(),

    helpers.createHappyPlugin('jsx'),
    helpers.createHappyPlugin('json'),
    helpers.createHappyPlugin('less'),
    helpers.createHappyPlugin('sass'),
  ]
};

if (process.env.WEBPACK_DLLS === '1' && validDLLs) {
  helpers.installVendorDLL(webpackConfig, 'vendor');
}

EOF
cat > ./webpack/webpack-dev-server.js << EOF
var Express = require('express');
var webpack = require('webpack');

var config = require('../src/config');
var webpackConfig = require('./dev.config');
var compiler = webpack(webpackConfig);

var host = config.host || 'localhost';
var port = (Number(config.port) + 1) || $wpport;
var serverOptions = {
  contentBase: 'http://' + host + ':' + port + '/frontdev',
  quiet: true,
  noInfo: true,
  hot: true,
  inline: true,
  lazy: false,
  publicPath: webpackConfig.output.publicPath,
  headers: { 'Access-Control-Allow-Origin': '*' },
  stats: { colors: true }
};

var app = new Express();

app.use(require('webpack-dev-middleware')(compiler, serverOptions));
app.use(require('webpack-hot-middleware')(compiler));

app.listen(port, function onAppListening(err) {
  if (err) {
    console.error(err);
  } else {
    console.info('==> 🚧  Webpack development server listening on port %s', port);
  }
});

EOF
npm install