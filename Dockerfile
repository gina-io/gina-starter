FROM node:22-slim

# gina-init and gina-container expect a writable home directory
ENV HOME=/home/node
RUN mkdir -p $HOME && chown node:node $HOME

WORKDIR /app

# Install gina globally. This runs as root, and gina's postinstall seeds
# $HOME/.gina, so hand $HOME and /app back to the node user in the same RUN.
RUN npm install -g gina@latest --unsafe-perm && chown -R node:node $HOME /app

# Copy project source
COPY --chown=node:node . .

# Install project dependencies (if any). package.json lists gina, so this
# re-runs gina's postinstall as root: hand $HOME back again, and /app with the
# node_modules it created (gina project:add relinks node_modules/gina below).
RUN { [ -f package-lock.json ] && npm ci --omit=dev || npm install --omit=dev; } && chown -R node:node $HOME /app

# require('gina') must resolve the global install that gina-init and
# gina-container run from, not the project's own copy.
RUN mkdir -p node_modules && rm -rf node_modules/gina && ln -sfn /usr/local/lib/node_modules/gina node_modules/gina

# Switch to non-root user
USER node

# The bundle reads manifest.json at boot, and the starter does not commit it:
# create it, and register the demo bundle's existing source, as the dev
# container does. This runs before gina-init, which the entrypoint runs.
RUN gina project:add @myproject --path=/app && gina bundle:add demo @myproject --import

# gina-init bootstraps ~/.gina/ from env vars (idempotent).
# gina-container starts the bundle in the foreground, forwards SIGTERM.
COPY --chown=node:node docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3100

ENTRYPOINT ["entrypoint.sh"]
CMD ["demo", "@myproject"]
