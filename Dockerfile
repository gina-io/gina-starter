FROM node:22-slim

# gina-init and gina-container expect a writable home directory
ENV HOME=/home/node
RUN mkdir -p $HOME && chown node:node $HOME

WORKDIR /app

# Install gina globally (the --unsafe-perm flag lets lifecycle scripts run as node)
RUN npm install -g gina@latest --unsafe-perm

# Copy project source
COPY --chown=node:node . .

# Install project dependencies (if any)
RUN [ -f package-lock.json ] && npm ci --omit=dev || npm install --omit=dev

# Switch to non-root user
USER node

# gina-init bootstraps ~/.gina/ from env vars (idempotent).
# gina-container starts the bundle in the foreground, forwards SIGTERM.
COPY --chown=node:node docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3100

ENTRYPOINT ["entrypoint.sh"]
CMD ["demo", "@myproject"]
