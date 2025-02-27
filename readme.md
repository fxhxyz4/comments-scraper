### Comments scraper extension

### _written with coffeescript and webpack_

### ![GitHub package.json version (subfolder of monorepo)](https://img.shields.io/github/package-json/v/fxhxyz4/comments-scraper) ![GitHub](https://img.shields.io/github/license/fxhxyz4/comments-scraper) ![Website](https://img.shields.io/website?url=https%3A%2F%2Ffxhxyz4.github.io%2Fcomments-scraper) ![GitHub issues](https://img.shields.io/github/issues/fxhxyz4/comments-scraper)

#

### _This extension efficiently extracts comments from youtube videos by leveraging CoffeeScript for concise and readable code and Webpack for optimized bundling._

#

### installation

```bash
git clone https://github.com/fxhxyz4/comments-scraper.git && cd comments-scraper && npm i
```

#

### create google API KEY

- [google console](https://console.cloud.google.com/apis/dashboard)

#

### development

```bash
npm run dev
```

- [x] for **disabling** csp eval error - devtool: _false in webpack config_

#

### production build

- **npm**

```bash
npm run prettier && npm run prod
```

- **shell**

```bash
sudo chmod +x ./build.sh && ./build.sh
```

- **batch**

```bash
./build.bat
```

#

### suggestions:

- [issues](https://github.com/fxhxyz4/comments-scraper/issues)
- [discussion](https://github.com/fxhxyz4/comments-scraper/discussions)

#

### License: [MIT](https://fxhxyz.mit-license.org)
