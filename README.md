# gina-starter

Minimal starter project for [Gina](https://gina.io) — one bundle, one route, one HTML template. Clone it and have a running server in under a minute.

## Prerequisites

- Node.js >= 18
- Gina CLI installed globally: `npm install -g gina`

## Quick start

```bash
# 1. Clone
git clone https://github.com/gina-io/gina-starter.git myproject
cd myproject

# 2. Register the project and bundle with the Gina CLI
gina project:add @myproject --path=$(pwd)
gina bundle:add demo @myproject

# 3. Start
gina bundle:start demo @myproject
```

Open your browser at the URL printed in the terminal output (e.g. `http://localhost:3100/`).
You should see **Hello World !**

## What's inside

```
src/
└── demo/
    ├── config/
    │   ├── app.json            Bundle identity and constants
    │   ├── routing.json        GET / → content#home
    │   ├── settings.json       Locale and region
    │   ├── settings.server.json  Webroot
    │   ├── templates.json      Template definitions (layout, CSS, JS)
    │   ├── connectors.json     Database connectors (empty — add yours here)
    │   └── watchers.json       File watchers (empty)
    ├── controllers/
    │   ├── controller.js       Base controller (shared helpers)
    │   ├── controller.content.js  content namespace — home action
    │   └── setup.js            Swig filter extension point
    ├── public/
    │   └── css/
    │       ├── default.css     Global styles
    │       └── home.css        Home-page styles
    ├── templates/
    │   ├── handlers/main.js    Client-side JS entry point
    │   └── html/
    │       ├── layouts/main.html     HTML shell
    │       ├── content/homepage.html  Home page block
    │       └── includes/             Noscript / outdated-browser banners
    └── index.js                Bundle bootstrap
```

## Stopping the bundle

```bash
gina bundle:stop demo @myproject
```

## Next steps

- Add a namespace: `gina namespace:add demo/blog @myproject`
- Add a connector in `config/connectors.json` and create entities under `models/`
- Read the docs: https://gina.io/docs
