#!/usr/bin/env bash
set -euo pipefail

CLAUDE_VERSION="${VERSION:-latest}"

# The feature runtime tells us who the container will actually run as
USERNAME="${_REMOTE_USER:-root}"
USER_HOME="${_REMOTE_USER_HOME:-/root}"

FEATURE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export DEBIAN_FRONTEND=noninteractive

# Node comes from the node feature we depend on; Debian's is too old for
# Claude Code, which asks for node 22 or newer. The rest is for init-firewall.sh.
apt-get update
apt-get -qq install -y --no-install-recommends \
    ca-certificates \
    curl \
    sudo \
    iptables \
    ipset \
    iproute2 \
    dnsutils \
    aggregate \
    jq
rm -rf /var/lib/apt/lists/*

npm install -g "@anthropic-ai/claude-code@${CLAUDE_VERSION}"

# Firewall, run from postStartCommand. It needs root, so allow this one command
# without a password.
install -m 0755 "${FEATURE_DIR}/init-firewall.sh" /usr/local/bin/init-firewall.sh
if [ "${USERNAME}" != "root" ]; then
    echo "${USERNAME} ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" \
        > "/etc/sudoers.d/${USERNAME}-firewall"
    chmod 0440 "/etc/sudoers.d/${USERNAME}-firewall"
fi

# Template for site-specific settings, so it is available inside the container
install -D -m 0644 "${FEATURE_DIR}/claude.env.example" \
    /usr/local/share/claude-devcontainer/claude.env.example

# Shared permission rules
install -D -m 0644 "${FEATURE_DIR}/settings.json" "${USER_HOME}/.claude/settings.json"
chown -R "${USERNAME}:" "${USER_HOME}/.claude"

# Load site-specific configuration on shell start, if the developer made one
cat >> "${USER_HOME}/.bashrc" << 'EOF'

# Load site-specific Claude Code configuration, if present.
if [ -n "${CLAUDE_ENV_FILE:-}" ] && [ -f "${CLAUDE_ENV_FILE}" ]; then
    . "${CLAUDE_ENV_FILE}"
fi
EOF
chown "${USERNAME}:" "${USER_HOME}/.bashrc"

echo "Installed Claude Code for ${USERNAME}."
