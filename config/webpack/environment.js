const { environment } = require('@rails/webpacker')
const { VueLoaderPlugin } = require('vue-loader')
const vue = require('./loaders/vue')
const webpack = require('webpack')

for (let loader of ["sass", "moduleSass"]) {
  const sassLoader = environment.loaders
    .get(loader)
    .use.find((el) => el.loader === "sass-loader");
  sassLoader.options.implementation = require("sass");
}

environment.plugins.prepend('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default'],
  moment: 'moment'
}))

environment.plugins.prepend('VueLoaderPlugin', new VueLoaderPlugin())
environment.loaders.prepend('vue', vue)
module.exports = environment
