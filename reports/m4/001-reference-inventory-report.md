# M4 reference inventory

Audit date: 2026-09-25. This was read-only on the M4.

## Machine and controller

- macOS 27.0 (26A428), Apple silicon.
- Approximately 14 GiB free on the startup volume; recorded only, with no cleanup performed.
- Live controller: `/Users/derek/Developer/mac-migration-control`.
- The controller is now on `main`; its preserved M4 audit claim and PATH repair are published to the shared controller branch.

## Developer baseline

- Homebrew includes the expected developer stack: Git, GitHub CLI, Docker CLI, Bun, Deno, Gradle, OpenJDK, PlatformIO, Python 3.12/3.14, Neovim, tmux, and supporting CLI utilities.
- Main developer applications include Android Studio, Arduino IDE, Cursor, Docker, Ollama, Visual Studio Code, VMware Fusion, Xcode beta, and Zed.
- Key projects under `~/Code` are listed in the M3 reconciliation task; no repositories were opened, changed, or copied.
- Git global identity is configured. SSH access was used only for this audit; no credentials were read or changed.

## M3 comparison result

- No M4 Homebrew formula is absent on M3.
- M3 has the standard Xcode app and the core developer CLIs required for daily use.
- The only reference application/cask differences are `Xcode-beta.app`, `NotchNook.app`, and Homebrew cask `sikarugir`; these remain opt-in.
- M4 project repositories are not present under M3's `~/Code`; reconciliation is queued rather than performed automatically.
