#!/usr/bin/env bash
set -euo pipefail

# Runs from postStartCommand
# Usage: claude-start.sh <workspace-folder>

WORKSPACE="${1:-}"

# An explicit CLAUDE_ENV_FILE from the devcontainer.json
ENV_FILE="${CLAUDE_ENV_FILE:-${WORKSPACE}/.devcontainer/claude.env}"

printf 'export CLAUDE_ENV_FILE=%q\n' "${ENV_FILE}" > "${HOME}/.claude-env-file"
sudo /usr/local/bin/init-firewall.sh "${ENV_FILE}"
