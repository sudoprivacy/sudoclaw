---
summary: "CLI reference for `sudoclaw config` (get/set/unset values and config file path)"
read_when:
  - You want to read or edit config non-interactively
title: "config"
---

# `sudoclaw config`

Config helpers: get/set/unset values by path and print the active config file.
Run without a subcommand to open
the configure wizard (same as `sudoclaw configure`).

## Examples

```bash
sudoclaw config file
sudoclaw config get browser.executablePath
sudoclaw config set browser.executablePath "/usr/bin/google-chrome"
sudoclaw config set agents.defaults.heartbeat.every "2h"
sudoclaw config set agents.list[0].tools.exec.node "node-id-or-name"
sudoclaw config unset tools.web.search.apiKey
```

## Paths

Paths use dot or bracket notation:

```bash
sudoclaw config get agents.defaults.workspace
sudoclaw config get agents.list[0].id
```

Use the agent list index to target a specific agent:

```bash
sudoclaw config get agents.list
sudoclaw config set agents.list[1].tools.exec.node "node-id-or-name"
```

## Values

Values are parsed as JSON5 when possible; otherwise they are treated as strings.
Use `--strict-json` to require JSON5 parsing. `--json` remains supported as a legacy alias.

```bash
sudoclaw config set agents.defaults.heartbeat.every "0m"
sudoclaw config set gateway.port 19001 --strict-json
sudoclaw config set channels.whatsapp.groups '["*"]' --strict-json
```

## Subcommands

- `config file`: Print the active config file path (resolved from `SUDOCLAW_CONFIG_PATH` or default location).

Restart the gateway after edits.
