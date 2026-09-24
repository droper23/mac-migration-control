# Mac setup relay

This folder lets two command-line agents coordinate through one private GitHub repository. It is designed for a migration from an older M4 MacBook Pro to a new M3 Max MacBook Pro.

| Computer | Agent | Role |
| --- | --- | --- |
| New M3 Max | Claude Code | Lead: set up and verify the new daily-driver Mac |
| Old M4 | Codex | Reference worker: audit the old Mac and publish a comparison report |

Each Mac has a LaunchAgent that wakes once per minute. It pulls the GitHub repository, looks only for queued work assigned to that Mac, runs its assigned agent, commits its report, and pushes it. The other Mac picks that up on its next minute. A Mac must be awake, online, and logged in for its worker to run.

## One-time start

1. AirDrop this folder to the **new M3 Max**, open Terminal there, then run:

   ```bash
   cd ~/Downloads/mac-ai-setup-orchestrator
   ./install-primary.sh
   ```

   It creates a private GitHub repo named `mac-migration-control`, pushes the controller, and installs the lead worker. It requires `gh` to be signed in and Claude Code to already be logged in.

2. The script prints one clone command. Run that exact command on the **old M4** and then run:

   ```bash
   ./install-reference-worker.sh
   ```

   Codex makes an inventory of the older Mac and pushes it to the repo. Claude on the M3 uses it as a comparison source and works through the setup.

3. Leave both Macs awake with power connected for the first setup pass. Watch progress in `STATUS.md`, `reports/`, and `tasks/` in either clone or on GitHub. The workers stop spending model usage when no task is queued.

## Limits that still require you

The agents can install and configure normal developer software without further prompts in this setup. macOS cannot let them bypass Apple Account, password, Touch ID, MFA, license, keychain, or screen-recording/accessibility dialogs. When one appears, complete it once; the controller resumes on its next run.

## Stop or remove

```bash
launchctl bootout gui/$(id -u) ~/Library/LaunchAgents/com.derek.mac-migration-*.plist
```
