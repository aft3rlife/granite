const postcssConfig = {
  plugins: {
    'postcss-normalize': {},
    'autoprefixer': {}
  }
}

// Compress CSS with cssnano in production
if (process.env.NODE_ENV === 'production') {
  postcssConfig.plugins['cssnano'] = {}
}

module.exports = postcssConfig
