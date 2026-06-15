# grok-cua-desktop (Pure Raw Official CUA)

Teaching material + skill for Grok Build agents (and others) to use the **official** CUA driver for real desktop control.

**Rule:** Always install the actual driver from https://github.com/trycua/cua. This repo only teaches effective usage and provides the Grok-specific skill definition. No custom wrappers.

## Installation (official only)

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/trycua/cua/main/libs/cua-driver/scripts/install.sh)"
```

## For Agents — Pure Raw Approach

The skill teaches you to **discover the real surface every time** instead of relying on a custom layer.

Core commands to start with in any new session:
- `cua-driver doctor`
- `cua-driver list-tools`
- `cua-driver describe <tool>`

See SKILL.md for full patterns (Linux pid+window_id targeting, agent cursors, recording, combining with chrome-devtools MCP, etc.).

This gives you the full unfiltered power of CUA.
