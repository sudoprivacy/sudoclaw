---
summary: "CLI reference for `sudoclaw logs` (tail gateway logs via RPC)"
read_when:
  - You need to tail Gateway logs remotely (without SSH)
  - You want JSON log lines for tooling
title: "logs"
---

# `sudoclaw logs`

Tail Gateway file logs over RPC (works in remote mode).

Related:

- Logging overview: [Logging](/logging)

## Examples

```bash
sudoclaw logs
sudoclaw logs --follow
sudoclaw logs --json
sudoclaw logs --limit 500
sudoclaw logs --local-time
sudoclaw logs --follow --local-time
```

Use `--local-time` to render timestamps in your local timezone.
