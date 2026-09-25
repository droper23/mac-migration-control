# M3 readiness audit

Audit date: 2026-09-25.

## Verified ready

- macOS 27.2 on Apple silicon with approximately 221 GiB free on the startup volume.
- Full Xcode is selected at `/Applications/Xcode.app/Contents/Developer`.
- Homebrew, Git, SSH, Docker, Visual Studio Code, Zed, Claude, Codex, Freebuff, Node/npm, Python/uv, and Ollama are installed and available.
- The installed Homebrew formula set covers every formula found on the M4 reference Mac.
- The M3 launch agent now points to `/Users/derek/Downloads/mac-ai-setup-orchestrator` and has an explicit PATH suitable for the worker.

## Deliberately deferred

- The M4 project's repositories are not automatically copied or cloned; see `002-project-repository-reconciliation.md`.
- `Xcode-beta.app`, `NotchNook.app`, and cask `sikarugir` are optional reference-machine items and were not installed automatically.

No Apple Account, privacy/security, backup, SSH, Git repository, or other unrelated settings were changed.
