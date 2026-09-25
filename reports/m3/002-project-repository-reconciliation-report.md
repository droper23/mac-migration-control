# Project repository reconciliation on M3

Audit date: 2026-09-25. Read-only: no repository was cloned, copied, altered, or had its remote changed.

## Finding: path mismatch, not missing data

`/Users/derek/Code` does not exist on M3 (confirmed absent; no symlink or case-variant either). All 14 reference repositories from the M4 list are present on M3, but under `/Users/derek/Projects/Code/...` instead of `/Users/derek/Code/...`. Each was verified as a real git checkout with the expected origin remote:

| Reference path | Found at | Origin remote | Branch | Sync vs. origin | Working tree |
|---|---|---|---|---|---|
| Cosmos-Music-Player | Projects/Code/Cosmos-Music-Player | github.com/clquwu/Cosmos-Music-Player.git | main | even (0 ahead/0 behind) | 26 modified files |
| Embedded/ESPresso | Projects/Code/Embedded/ESPresso | github.com/droper23/ESPresso.git | main | even | 45 modified files |
| Embedded/espr-vscode-ext | Projects/Code/Embedded/espr-vscode-ext | github.com/droper23/espr-language.git | main | even | 7 changed/untracked files |
| Farsi/farsi-learn | Projects/Code/Farsi/farsi-learn | github.com/droper23/farsi-learn.git | main | even | 3 untracked files |
| Hungarian/hungarian-taivuta | Projects/Code/Hungarian/hungarian-taivuta | github.com/droper23/hungarian_drills | main | even | 7 changed files |
| Racing Team/Sensor_Hub | Projects/Code/Racing Team/Sensor_Hub | github.com/BYU-Racing/Sensor_Hub.git | main | even | 3 changed/untracked files |
| School/learningsuite-project | Projects/Code/School/learningsuite-project | github.com/droper23/docket.git | main | even | 2 untracked files |
| _holding/zsh-autosuggestions | Projects/Code/_holding/zsh-autosuggestions | github.com/zsh-users/zsh-autosuggestions | master | even | 3 untracked (.DS_Store) files |
| _holding/zsh-syntax-highlighting | Projects/Code/_holding/zsh-syntax-highlighting | github.com/zsh-users/zsh-syntax-highlighting.git | master | even | 2 untracked (.DS_Store) files |
| ecen224-course | Projects/Code/ecen224-course | github.com/droper23/ecen224-course.git | main | even | clean |
| focus-study-app | Projects/Code/focus-study-app | github.com/droper23/deep-focus.git | main | even | clean |
| learn-assembly | Projects/Code/learn-assembly | github.com/droper23/learn-assembly.git | main | even | 48 changed files |
| math113-course | Projects/Code/math113-course | github.com/droper23/math113-course.git | main | even | clean |
| study-radar | Projects/Code/study-radar | github.com/droper23/study-radar.git | main | even | 9 untracked (.DS_Store) files |

"Even" means `git rev-list --left-right --count origin/<branch>...HEAD` returned `0 0` — the local branch has neither unpushed commits nor missing commits relative to its own remote. Dirty/untracked files are normal working-tree state, not evidence of a broken clone.

## Note: a naming collision to be aware of

`/Users/derek/Projects/Code/learningsuite-project` (top level, no `School/` prefix) also exists but is **not** a git repository — it only contains a `data` subfolder and is unrelated to the reference item. The actual match for the M4 reference list is `Projects/Code/School/learningsuite-project`, which is the proper `docket.git` checkout.

## Conclusion

No cloning, copying, or remote changes were needed or performed — every reference repository already exists on M3 with a correct, in-sync remote. The only discrepancy is that the M4 reference list assumes a `~/Code` root while M3 uses `~/Projects/Code`. This is a path/documentation mismatch, not a data-loss or missing-repository issue.

**Owner decision needed:** whether to (a) leave M3's `~/Projects/Code` layout as-is and update the reference inventory notes accordingly, (b) add a symlink `~/Code -> ~/Projects/Code` for path parity with M4, or (c) something else. No filesystem or git change was made pending that direction.
