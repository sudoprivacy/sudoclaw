#!/usr/bin/env bash
set -euo pipefail

cd /repo

export SUDOCLAW_STATE_DIR="/tmp/openclaw-test"
export SUDOCLAW_CONFIG_PATH="${SUDOCLAW_STATE_DIR}/openclaw.json"

echo "==> Build"
pnpm build

echo "==> Seed state"
mkdir -p "${SUDOCLAW_STATE_DIR}/credentials"
mkdir -p "${SUDOCLAW_STATE_DIR}/agents/main/sessions"
echo '{}' >"${SUDOCLAW_CONFIG_PATH}"
echo 'creds' >"${SUDOCLAW_STATE_DIR}/credentials/marker.txt"
echo 'session' >"${SUDOCLAW_STATE_DIR}/agents/main/sessions/sessions.json"

echo "==> Reset (config+creds+sessions)"
pnpm openclaw reset --scope config+creds+sessions --yes --non-interactive

test ! -f "${SUDOCLAW_CONFIG_PATH}"
test ! -d "${SUDOCLAW_STATE_DIR}/credentials"
test ! -d "${SUDOCLAW_STATE_DIR}/agents/main/sessions"

echo "==> Recreate minimal config"
mkdir -p "${SUDOCLAW_STATE_DIR}/credentials"
echo '{}' >"${SUDOCLAW_CONFIG_PATH}"

echo "==> Uninstall (state only)"
pnpm openclaw uninstall --state --yes --non-interactive

test ! -d "${SUDOCLAW_STATE_DIR}"

echo "OK"
