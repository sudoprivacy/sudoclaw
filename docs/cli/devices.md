---
summary: "CLI reference for `sudoclaw devices` (device pairing + token rotation/revocation)"
read_when:
  - You are approving device pairing requests
  - You need to rotate or revoke device tokens
title: "devices"
---

# `sudoclaw devices`

Manage device pairing requests and device-scoped tokens.

## Commands

### `sudoclaw devices list`

List pending pairing requests and paired devices.

```
sudoclaw devices list
sudoclaw devices list --json
```

### `sudoclaw devices remove <deviceId>`

Remove one paired device entry.

```
sudoclaw devices remove <deviceId>
sudoclaw devices remove <deviceId> --json
```

### `sudoclaw devices clear --yes [--pending]`

Clear paired devices in bulk.

```
sudoclaw devices clear --yes
sudoclaw devices clear --yes --pending
sudoclaw devices clear --yes --pending --json
```

### `sudoclaw devices approve [requestId] [--latest]`

Approve a pending device pairing request. If `requestId` is omitted, SudoClaw
automatically approves the most recent pending request.

```
sudoclaw devices approve
sudoclaw devices approve <requestId>
sudoclaw devices approve --latest
```

### `sudoclaw devices reject <requestId>`

Reject a pending device pairing request.

```
sudoclaw devices reject <requestId>
```

### `sudoclaw devices rotate --device <id> --role <role> [--scope <scope...>]`

Rotate a device token for a specific role (optionally updating scopes).

```
sudoclaw devices rotate --device <deviceId> --role operator --scope operator.read --scope operator.write
```

### `sudoclaw devices revoke --device <id> --role <role>`

Revoke a device token for a specific role.

```
sudoclaw devices revoke --device <deviceId> --role node
```

## Common options

- `--url <url>`: Gateway WebSocket URL (defaults to `gateway.remote.url` when configured).
- `--token <token>`: Gateway token (if required).
- `--password <password>`: Gateway password (password auth).
- `--timeout <ms>`: RPC timeout.
- `--json`: JSON output (recommended for scripting).

Note: when you set `--url`, the CLI does not fall back to config or environment credentials.
Pass `--token` or `--password` explicitly. Missing explicit credentials is an error.

## Notes

- Token rotation returns a new token (sensitive). Treat it like a secret.
- These commands require `operator.pairing` (or `operator.admin`) scope.
- `devices clear` is intentionally gated by `--yes`.
- If pairing scope is unavailable on local loopback (and no explicit `--url` is passed), list/approve can use a local pairing fallback.
