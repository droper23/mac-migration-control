# Mac migration status

This file is the shared source of truth. Workers update it after each task.

## Initial state

- New M3 Max: Migration Assistant transfer completed; needs full verification.
- Old M4: Retain as the reference machine until the new Mac is confirmed stable.

## 2026-09-25 controller update

- The live M3 controller is `/Users/derek/Downloads/mac-ai-setup-orchestrator`; its launch agent was repaired to use that path and an explicit developer-tool PATH.
- The live M4 controller is `/Users/derek/Developer/mac-migration-control`. Its `master`/`main` mismatch was repaired while preserving the existing M4 audit claim; the shared `main` branch now contains the worker PATH fix.
- M4 reference inventory and M3 readiness audit are complete. Core developer tooling matches the M4 reference on M3: Homebrew formulae, standard Xcode, Docker, Claude, Codex, Freebuff, Node/npm, Python/uv, Ollama, Git, and SSH are present.
- M4 has approximately 14 GiB free. This is recorded for monitoring only; no M4 data or settings were changed.
- Follow-ups are queued for opt-in project-repository reconciliation and optional applications that are not appropriate to install automatically.
