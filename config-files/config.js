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
  port: 5000,
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
