# gina-starter

Minimal starter project for [Gina](https://gina.io) — one bundle, one route, one HTML template. Clone it and have a running server in under a minute.

## Prerequisites

- Node.js >= 22
- Gina CLI installed globally: `npm install -g gina` (see the [installation guide](https://gina.io/docs/getting-started/installation))
- On Windows: run these steps inside WSL2, or use the [dev container](#dev-container)

## Quick start

```bash
# 1. Clone
git clone https://github.com/gina-io/gina-starter.git myproject
cd myproject

# 2. Register the project and bundle with the Gina CLI
gina project:add @myproject --path=$(pwd)
gina bundle:add demo @myproject

# 3. Start the framework, then the bundle
gina start
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
gina stop    # stops the framework too
```

## Docker Compose

Run the bundle in a container — no local Node.js install required.

**Prerequisites:** [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) 2.20 or later.

```bash
docker compose up
```

Open `http://localhost:3100/`. You should see **Hello World !**

The image registers the project and its `demo` bundle while it builds (`gina project:add`, then `gina bundle:add --import`), so it needs no `manifest.json` or `env.json` from your clone; `.dockerignore` keeps out the ones your local setup wrote.

### With Couchbase

The compose file also defines a Couchbase Community Edition server, behind the `couchbase` profile:

| Service | Port | Purpose |
|---|---|---|
| `app` | 3100 | Gina bundle (`demo`) |
| `couchbase` | 8091 | Couchbase Community Edition admin console |
| `couchbase-init` | — | One-shot: creates the cluster, the `demo` bucket, the `appuser` user and sample data |

To connect the bundle to it:

```bash
cp docker/connectors.json src/demo/config/connectors.json
npm pkg set dependencies.couchbase=^4
docker compose --profile couchbase up --build
```

- The first line activates the Couchbase connector the starter ships in `docker/connectors.json`. Gina does not read it there (inside `src/demo/config/` it would be loaded as a second connector set named `docker`, and the bundle would not start).
- The second adds the Couchbase Node.js SDK to `package.json`, and the image installs it: Gina loads the SDK from the project's `node_modules`. Without Node.js on your machine, add `"couchbase": "^4"` to `dependencies` by hand.
- The bundle connects as `appuser`. Its password comes from `CB_PASS` in `docker-compose.yml`, through the `${secret:CB_PASS}` placeholder.

Open `http://localhost:8091/` for the Couchbase admin console (login: `Administrator` / `administrator`). Sample documents are pre-seeded in the `demo` bucket — query them from entity models under `src/demo/models/demo/entities/`. See the [Models & entities guide](https://gina.io/docs/guides/models) for details.

### Stopping and cleaning up

```bash
docker compose down                          # stop the app
docker compose --profile couchbase down      # stop everything; the Couchbase data stays in its volume
docker compose --profile couchbase down -v   # stop everything and delete the Couchbase data
```

Without `--profile couchbase`, `down` leaves the Couchbase containers running.

## Next steps

- Add a namespace: `gina namespace:add demo/blog @myproject`
- Add a connector in `config/connectors.json` and create entities under `models/`
- Read the docs: https://gina.io/docs
