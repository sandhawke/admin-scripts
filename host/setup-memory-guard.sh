#!/usr/bin/env bash

set -euo pipefail

if [[ "${EUID}" -ne 0 ]]; then
  exec sudo --preserve-env=DEBIAN_FRONTEND bash "$0" "$@"
fi

export DEBIAN_FRONTEND="${DEBIAN_FRONTEND:-noninteractive}"

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "missing required command: $1" >&2
    exit 1
  fi
}

require_command apt-get
require_command systemctl
require_command install

echo "Installing earlyoom..."
apt-get update
apt-get install -y earlyoom

echo "Writing /etc/default/earlyoom..."
cat > /etc/default/earlyoom <<'EOF'
# Default settings for earlyoom. This file is sourced by /bin/sh from
# /etc/init.d/earlyoom or by systemd from earlyoom.service.

# Options to pass to earlyoom
#
# This VM is small enough that "recover fast" is better than swapping or
# reclaim thrash. Trigger on low available memory regardless of swap state,
# and kill the whole offending process group so background job trees get
# cleaned up together.
EARLYOOM_ARGS="-g -m 10,5 -s 100,100 -r 60"

# Examples:

# Print memory report every minute instead of every hour
# EARLYOOM_ARGS="-r 60"

# Available minimum memory 5%
# EARLYOOM_ARGS="-m 5"

# Available minimum memory 15% and free minimum swap 5%
# EARLYOOM_ARGS="-m 15 -s 5"

# Avoid killing processes whose name matches this regexp
# EARLYOOM_ARGS="--avoid '(^|/)(init|X|sshd|firefox)$'"

# See more at `earlyoom -h'
EOF

echo "Writing /etc/sysctl.d/99-memory-pressure.conf..."
cat > /etc/sysctl.d/99-memory-pressure.conf <<'EOF'
# If swap is enabled later, strongly prefer reclaiming/killing over swapping.
vm.swappiness = 1
EOF

echo "Applying kernel and service changes..."
systemctl restart systemd-sysctl
systemctl enable --now earlyoom
systemctl restart earlyoom

echo
echo "Configured earlyoom and swappiness."
echo "Current earlyoom command:"
systemctl show -p ExecStart earlyoom
echo
echo "Current swappiness:"
cat /proc/sys/vm/swappiness
