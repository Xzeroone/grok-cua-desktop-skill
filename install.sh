#!/usr/bin/env bash
set -euo pipefail

echo "Installing official CUA driver from trycua/cua..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/trycua/cua/main/libs/cua-driver/scripts/install.sh)"

echo ""
echo "Official cua-driver installed."
echo "See the skill (and this repo) for how Grok-style agents should discover and use the raw tool surface."
