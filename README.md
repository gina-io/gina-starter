# gina-starter

Minimal starter project for [Gina](https://gina.io) — one bundle, one route, one HTML template. Clone it and have a running server in under a minute.

## Prerequisites

- Node.js >= 18
- Gina CLI installed globally: `npm install -g gina`
- On Windows: run these steps inside WSL2, or use the [dev container](#dev-container)

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

## Dev container

The repository includes a [dev container](.devcontainer/devcontainer.json): Node.js 24 on Debian, with the Gina CLI installed for the container's `node` user. Open the folder in VS Code with the [Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers) extension (**Dev Containers: Reopen in Container**), or in [GitHub Codespaces](https://github.com/features/codespaces).

- When the container is created, it installs Gina and registers the project and the `demo` bundle.
- Each time it starts, it starts the framework, then the bundle.
- Port 3100 is forwarded: open `http://localhost:3100/` (in Codespaces, open the port from the **Ports** tab).

The dev container is for development. To run a bundle in a production container, see [K8s and Docker](https://gina.io/docs/guides/k8s-docker).

### On Windows

Use Docker Desktop with its WSL 2 backend, and keep the source in the Linux file system:

- clone the repository in a WSL terminal, under your Linux home directory, then open it from there (`code .`, then **Reopen in Container**);
- or run **Dev Containers: Clone Repository in Container Volume**;
- or use Codespaces.

Don't open a clone that sits on the Windows drive (`C:\…`, which WSL shows as `/mnt/c/…`). Docker [documents](https://docs.docker.com/desktop/features/wsl/best-practices/) that containers receive file-change events only for files stored in the Linux file system, and in development Gina reloads a changed controller only when its file watcher reports the change. See also [Windows](https://gina.io/docs/getting-started/installation#windows) in the installation guide.

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
