### Comments scraper for youtube.com

### ![GitHub package.json version (subfolder of monorepo)](https://img.shields.io/github/package-json/v/fxhxyz4/comments-scraper) ![GitHub](https://img.shields.io/github/license/fxhxyz4/comments-scraper) ![Website](https://img.shields.io/website?url=https%3A%2F%2Ffxhxyz4.github.io%2Fcomments-scraper) ![GitHub issues](https://img.shields.io/github/issues/fxhxyz4/comments-scraper)

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
sudo chmod +x ./build.sh & ./build.sh
```

- **batch**

```bash
./build.bat
```

#

### TODO:

- [x] [comment thread replies](https://stackoverflow.com/questions/31546995/youtube-data-api-v3-commentthread-call-doesnt-give-replies-for-some-comment-th)

#

### suggestions:

- [issues](https://github.com/fxhxyz4/comments-scraper/issues)
- [discussion](https://github.com/fxhxyz4/comments-scraper/discussions)

#

### License: [MIT](https://fxhxyz.mit-license.org)
