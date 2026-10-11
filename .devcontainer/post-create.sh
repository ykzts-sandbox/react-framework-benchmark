#!/usr/bin/env bash

set -euo pipefail

curl -fsSL https://x.ai/cli/install.sh | bash

sudo chown -R node:node \
  /home/node/.claude \
  /home/node/.config \
  /home/node/.grok \
  /home/node/.local
