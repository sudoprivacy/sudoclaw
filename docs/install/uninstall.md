---
summary: "Uninstall SudoClaw completely (CLI, service, state, workspace)"
read_when:
  - You want to remove SudoClaw from a machine
  - The gateway service is still running after uninstall
title: "Uninstall"
---

# Uninstall

Two paths:

- **Easy path** if `sudoclaw` is still installed.
- **Manual service removal** if the CLI is gone but the service is still running.

## Easy path (CLI still installed)

Recommended: use the built-in uninstaller:

```bash
sudoclaw uninstall
```

Non-interactive (automation / npx):

```bash
sudoclaw uninstall --all --yes --non-interactive
npx -y sudoclaw uninstall --all --yes --non-interactive
```

Manual steps (same result):

1. Stop the gateway service:

```bash
sudoclaw gateway stop
```

2. Uninstall the gateway service (launchd/systemd/schtasks):

```bash
sudoclaw gateway uninstall
```

3. Delete state + config:

```bash
rm -rf "${SUDOCLAW_STATE_DIR:-$HOME/.sudoclaw}"
```

If you set `SUDOCLAW_CONFIG_PATH` to a custom location outside the state dir, delete that file too.

4. Delete your workspace (optional, removes agent files):

```bash
rm -rf ~/.sudoclaw/workspace
```

5. Remove the CLI install (pick the one you used):

```bash
npm rm -g sudoclaw
pnpm remove -g sudoclaw
bun remove -g sudoclaw
```

6. If you installed the macOS app:

```bash
rm -rf /Applications/SudoClaw.app
```

Notes:

- If you used profiles (`--profile` / `SUDOCLAW_PROFILE`), repeat step 3 for each state dir (defaults are `~/.sudoclaw-<profile>`).
- In remote mode, the state dir lives on the **gateway host**, so run steps 1-4 there too.

## Manual service removal (CLI not installed)

Use this if the gateway service keeps running but `sudoclaw` is missing.

### macOS (launchd)

Default label is `ai.sudoclaw.gateway` (or `ai.sudoclaw.<profile>`; legacy `com.sudoclaw.*` may still exist):

```bash
launchctl bootout gui/$UID/ai.sudoclaw.gateway
rm -f ~/Library/LaunchAgents/ai.sudoclaw.gateway.plist
```

If you used a profile, replace the label and plist name with `ai.sudoclaw.<profile>`. Remove any legacy `com.sudoclaw.*` plists if present.

### Linux (systemd user unit)

Default unit name is `sudoclaw-gateway.service` (or `sudoclaw-gateway-<profile>.service`):

```bash
systemctl --user disable --now sudoclaw-gateway.service
rm -f ~/.config/systemd/user/sudoclaw-gateway.service
systemctl --user daemon-reload
```

### Windows (Scheduled Task)

Default task name is `SudoClaw Gateway` (or `SudoClaw Gateway (<profile>)`).
The task script lives under your state dir.

```powershell
schtasks /Delete /F /TN "SudoClaw Gateway"
Remove-Item -Force "$env:USERPROFILE\.sudoclaw\gateway.cmd"
```

If you used a profile, delete the matching task name and `~\.sudoclaw-<profile>\gateway.cmd`.

## Normal install vs source checkout

### Normal install (install.sh / npm / pnpm / bun)

If you used `https://sudoclaw.ai/install.sh` or `install.ps1`, the CLI was installed with `npm install -g sudoclaw@latest`.
Remove it with `npm rm -g sudoclaw` (or `pnpm remove -g` / `bun remove -g` if you installed that way).

### Source checkout (git clone)

If you run from a repo checkout (`git clone` + `sudoclaw ...` / `bun run sudoclaw ...`):

1. Uninstall the gateway service **before** deleting the repo (use the easy path above or manual service removal).
2. Delete the repo directory.
3. Remove state + workspace as shown above.
