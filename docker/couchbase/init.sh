#!/bin/bash
#
# Couchbase Community Edition init script.
# Runs as a one-shot container after Couchbase is healthy.
# Sets up the cluster, creates a bucket, adds an application user,
# and inserts sample documents.
#
set -euo pipefail

CB_HOST="${CB_HOST:-couchbase}"
CB_USER="${CB_USER:-appuser}"
CB_PASS="${CB_PASS:-password123}"
CB_BUCKET="${CB_BUCKET:-demo}"
ADMIN_USER="Administrator"
ADMIN_PASS="administrator"

BASE="http://${CB_HOST}:8091"

# ── Wait for Couchbase to accept REST calls ───────────────────────────────────
echo "[init] Waiting for Couchbase REST API..."
until curl -sf "${BASE}/pools" > /dev/null 2>&1; do
    sleep 2
done
echo "[init] Couchbase is ready."

# ── Cluster init (skip if already initialised) ────────────────────────────────
if ! curl -sf -u "${ADMIN_USER}:${ADMIN_PASS}" "${BASE}/pools/default" > /dev/null 2>&1; then
    echo "[init] Initialising cluster..."

    # Memory quotas (MB) — Community Edition minimums
    curl -sf -X POST "${BASE}/pools/default" \
        -d memoryQuota=256 \
        -d indexMemoryQuota=256

    # Services
    curl -sf -X POST "${BASE}/node/controller/setupServices" \
        -d services=kv%2Cn1ql%2Cindex

    # Index storage (forestdb for CE)
    curl -sf -X POST "${BASE}/settings/indexes" \
        -d storageMode=forestdb

    # Admin credentials
    curl -sf -X POST "${BASE}/settings/web" \
        -d port=8091 \
        -d username="${ADMIN_USER}" \
        -d password="${ADMIN_PASS}"

    echo "[init] Cluster initialised."
else
    echo "[init] Cluster already initialised — skipping."
fi

# ── Create bucket ─────────────────────────────────────────────────────────────
if ! curl -sf -u "${ADMIN_USER}:${ADMIN_PASS}" "${BASE}/pools/default/buckets/${CB_BUCKET}" > /dev/null 2>&1; then
    echo "[init] Creating bucket '${CB_BUCKET}'..."
    curl -sf -X POST -u "${ADMIN_USER}:${ADMIN_PASS}" \
        "${BASE}/pools/default/buckets" \
        -d name="${CB_BUCKET}" \
        -d bucketType=couchbase \
        -d ramQuota=128 \
        -d flushEnabled=1

    # Wait for bucket to be ready
    sleep 3
    echo "[init] Bucket '${CB_BUCKET}' created."
else
    echo "[init] Bucket '${CB_BUCKET}' already exists — skipping."
fi

# ── Create application user ──────────────────────────────────────────────────
echo "[init] Creating application user '${CB_USER}'..."
curl -sf -X PUT -u "${ADMIN_USER}:${ADMIN_PASS}" \
    "${BASE}/settings/rbac/users/local/${CB_USER}" \
    -d password="${CB_PASS}" \
    -d roles="bucket_full_access[${CB_BUCKET}],query_select[${CB_BUCKET}],query_insert[${CB_BUCKET}],query_update[${CB_BUCKET}],query_delete[${CB_BUCKET}]" \
    || true  # ignore error if user already exists

echo "[init] User '${CB_USER}' ready."

# ── Create primary index (required for ad-hoc N1QL queries) ──────────────────
echo "[init] Creating primary index..."
curl -sf -X POST -u "${ADMIN_USER}:${ADMIN_PASS}" \
    "http://${CB_HOST}:8093/query/service" \
    -d "statement=CREATE PRIMARY INDEX IF NOT EXISTS ON \`${CB_BUCKET}\`" \
    || true

# ── Seed sample documents ────────────────────────────────────────────────────
echo "[init] Inserting sample documents..."
curl -sf -X POST -u "${ADMIN_USER}:${ADMIN_PASS}" \
    "http://${CB_HOST}:8093/query/service" \
    -d "statement=UPSERT INTO \`${CB_BUCKET}\` (KEY, VALUE) VALUES
        (\"greeting:hello\", {\"_type\": \"greeting\", \"_scope\": \"local\", \"message\": \"Hello from Couchbase!\", \"lang\": \"en\"}),
        (\"greeting:bonjour\", {\"_type\": \"greeting\", \"_scope\": \"local\", \"message\": \"Bonjour depuis Couchbase !\", \"lang\": \"fr\"}),
        (\"greeting:hola\", {\"_type\": \"greeting\", \"_scope\": \"local\", \"message\": \"Hola desde Couchbase!\", \"lang\": \"es\"})"

echo "[init] Sample data ready."
echo "[init] Done. Couchbase is fully configured."
