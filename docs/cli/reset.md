---
summary: "CLI reference for `sudoclaw reset` (reset local state/config)"
read_when:
  - You want to wipe local state while keeping the CLI installed
  - You want a dry-run of what would be removed
title: "reset"
---

# `sudoclaw reset`

Reset local config/state (keeps the CLI installed).

```bash
sudoclaw reset
sudoclaw reset --dry-run
sudoclaw reset --scope config+creds+sessions --yes --non-interactive
```
