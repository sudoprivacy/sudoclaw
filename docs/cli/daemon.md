---
summary: "CLI reference for `sudoclaw daemon` (legacy alias for gateway service management)"
read_when:
  - You still use `sudoclaw daemon ...` in scripts
  - You need service lifecycle commands (install/start/stop/restart/status)
title: "daemon"
---

# `sudoclaw daemon`

Legacy alias for Gateway service management commands.

`sudoclaw daemon ...` maps to the same service control surface as `sudoclaw gateway ...` service commands.

## Usage

```bash
sudoclaw daemon status
sudoclaw daemon install
sudoclaw daemon start
sudoclaw daemon stop
sudoclaw daemon restart
sudoclaw daemon uninstall
```

## Subcommands

- `status`: show service install state and probe Gateway health
- `install`: install service (`launchd`/`systemd`/`schtasks`)
- `uninstall`: remove service
- `start`: start service
- `stop`: stop service
- `restart`: restart service

## Common options

- `status`: `--url`, `--token`, `--password`, `--timeout`, `--no-probe`, `--deep`, `--json`
- `install`: `--port`, `--runtime <node|bun>`, `--token`, `--force`, `--json`
- lifecycle (`uninstall|start|stop|restart`): `--json`

## Prefer

Use [`sudoclaw gateway`](/cli/gateway) for current docs and examples.
