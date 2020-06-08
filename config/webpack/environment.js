const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: ['popper.js', 'default']
}))

// environment.config.merge({
//   module: {
//     rules: [
//       {
//         test: require.resolve('jquery'),
//         use: [{
//           loader: 'expose-loader',
//           options: '$'
//         }, {
//           loader: 'expose-loader',
//           options: 'jQuery'
//         }]
//       }
//     ],
//   },
// });

module.exports = environment
