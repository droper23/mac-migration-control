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
- Project-repository reconciliation on M3 is complete (audit-only, nothing changed): all 14 M4 reference repositories exist on M3, but under `~/Projects/Code/...` rather than `~/Code/...` (which does not exist on M3). Each was verified as a real git checkout with the correct origin remote and in sync with that remote (0 ahead/0 behind); dirty working trees are normal uncommitted local edits. No cloning, copying, or remote changes were needed or performed. See `reports/m3/002-project-repository-reconciliation-report.md`. Owner decision needed on whether to update the reference inventory's path assumption, symlink `~/Code` to `~/Projects/Code`, or leave as-is. Also note: `~/Projects/Code/learningsuite-project` (no `School/` prefix) is an unrelated non-git folder, not to be confused with the real `School/learningsuite-project` repo.
