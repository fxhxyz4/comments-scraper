import path from 'path';

const __path = `./`;
const __dirname = path.dirname(__path);

const client = {
  entry: './scripts/main.coffee',
  output: {
    filename: 'main.min.js',
    path: path.resolve(__dirname, 'dist'),
  },
  experiments: {
    topLevelAwait: true,
  },
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: {
          loader: 'coffee-loader',
          options: { sourceMap: false },
        },
      },
    ],
  },
};

export default client;
