#!/bin/sh
set -e

# Bootstrap ~/.gina/ state files from environment variables.
# Safe to run on every start — gina-init is idempotent.
gina-init

# Start the bundle in the foreground.
# Arguments default to "demo @myproject" (from Dockerfile CMD) but can be
# overridden at runtime:  docker run gina-starter api @myproject
exec gina-container "$@"
