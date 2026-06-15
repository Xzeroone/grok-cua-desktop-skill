name: grok-cua-desktop
description: Skill for using the official CUA driver (cua-driver from trycua/cua) for full desktop computer-use on Linux (and other OSes). Teaches discovery of the raw tool surface, common patterns (especially Linux X11/AT-SPI background control, agent cursors, recording), and how to combine it with existing capabilities like shell and chrome-devtools MCP. The goal is unfiltered, powerful access to the real CUA project capabilities.

# grok-cua-desktop (Raw CUA Driver Skill)

This skill teaches Grok Build agents (and similar) how to use the **official CUA driver** for real desktop control.

**Core rule:** The actual cua-driver binary and its full power always come from the official project at https://github.com/trycua/cua. This skill and its companion repo exist only to help agents discover, remember, and use it effectively — especially in Grok CLI/Build environments on Linux.

## Installation (official only)

Always install the driver from the official source:

```bash
# Linux (and cross-platform)
 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/trycua/cua/main/libs/cua-driver/scripts/install.sh)"
```

This puts the binary at `~/.cua-driver/packages/...` with a convenient symlink at `~/.local/bin/cua-driver`.

Verify with:
```bash
cua-driver --version
cua-driver doctor
```

## How to use it effectively (as an agent)

Do **not** hard-code specific tool calls from memory across sessions. **Discover the current surface every time.**

### 1. Discovery commands (use these first in a new session or when stuck)

```bash
cua-driver doctor                    # Health, OS support, permissions, AT-SPI/X11 status on Linux
cua-driver list-tools                # Full list of available tools (usually 30+)
cua-driver describe <tool-name>      # Exact input_schema + description for any tool
cua-driver --help                    # High-level subcommands (mcp, call, list_windows, etc.)
```

Key tools you will commonly need on Linux:
- `list_windows` — Best way to discover real top-level X11 windows (with pid + window_id).
- `get_window_state` — Rich output: Markdown tree of AT-SPI UI + optional screenshot. Requires both `pid` and `window_id`. Supports `capture_mode`: "som" (tree+screenshot), "ax" (tree only), "vision" (screenshot only).
- `click`, `type_text`, `press_key`, `drag`, `scroll`, `set_value`, `hotkey` — Background input via XSendEvent (does not steal real focus/mouse by default).
- `launch_app` — Launch apps (with `urls` array for direct web navigation).
- `get_accessibility_tree`, `get_cursor_position`, `get_screen_size`.
- Cursor overlay tools: `move_cursor`, `set_agent_cursor_enabled`, `get_agent_cursor_state`.
- Recording: `start_recording`, `stop_recording`, `get_recording_state`, `replay_trajectory`.
- `bring_to_front` (limited on Linux), `kill_app`, `launch_app`.

### 2. Common Linux patterns

- Always target actions with both `pid` and `window_id` from `list_windows` for precision.
- Input is injected via XSendEvent / AT-SPI — it works on background windows.
- Enable the synthetic agent cursor overlay so the human can see where you are acting:
  ```bash
  cua-driver call set_agent_cursor_enabled '{"enabled": true}'
  ```
- For vision + structure, prefer `capture_mode: "som"` in `get_window_state`.
- Use recording when doing multi-step or long-running GUI tasks for auditability/replay.
- Combine with other tools: use chrome-devtools MCP for deep browser DOM work, raw shell for terminal, and CUA for native desktop apps / full screen control.

### 3. MCP usage

The driver speaks MCP natively:

```bash
cua-driver mcp
```

Register example (for Claude Code / Cursor / other MCP clients):
```json
{
  "mcpServers": {
    "cua-driver": {
      "command": "~/.cua-driver/packages/releases/0.5.3-x86_64-unknown-linux-gnu/cua-driver",
      "args": ["mcp"]
    }
  }
}
```

### 4. Best practices for Grok-style agents

- Start every desktop session with `cua-driver doctor` and `cua-driver list-tools`.
- Prefer `get_window_state` with `som` mode when you need to "see" a window.
- Use agent cursors for transparency with the human.
- Record trajectories for anything non-trivial.
- On Linux the tool is pre-release but very usable (X11 + AT-SPI). Test with `doctor`.
- For pure browser tasks, the dedicated chrome-devtools MCP is often stronger; use CUA when you need native app control, file managers, system UI, etc.
- Input is background-capable — you can control apps without bringing them to the foreground unless necessary.

## Files in the companion repo

This skill lives at `~/.grok/skills/grok-cua-desktop/SKILL.md`.

The companion repo (https://github.com/Xzeroone/grok-cua-desktop-skill) contains:
- This SKILL.md (pure raw focus)
- README with agent-oriented guidance
- `install.sh` that installs only the official driver + this skill

We do **not** ship custom wrappers or high-level abstractions in the main teaching material. The goal is to give agents direct, high-fidelity access to the real CUA surface.

## References

- Official project: https://github.com/trycua/cua (always install from here)
- Driver docs: https://cua.ai/docs/cua-driver
- Linux specifics: X11/AT-SPI, xdg-open for launching, etc.

This approach gives you the "best thing in the world" — the full, unfiltered power of the official CUA driver, with a skill that helps you discover and wield it reliably across sessions.
