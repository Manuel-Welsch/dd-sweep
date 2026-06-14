# dd-prune

Prune orphaned **Xcode DerivedData** — the build caches left behind when a
worktree or clone is deleted. Safe by default: it lists what it would remove,
and only ever moves caches to the **Trash** (never a hard delete).

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/Manuel-Welsch/dd-prune/main/install.sh | bash
```

Installs `dd-prune` into `~/bin` (or `~/.local/bin` if that's the one on your
PATH). Override with `DD_PRUNE_BIN=~/somewhere ./install.sh`.

## Usage

```bash
dd-prune                     # dry-run: list reclaimable caches + total size
dd-prune --apply             # move them to the Trash (reversible)
dd-prune --prefix DottedMind # scope to one project
dd-prune --help
```

## How it decides

Each DerivedData folder records the `.xcodeproj` / `.xcworkspace` it was built
from. A folder is **reclaimable** when that source path no longer exists on disk
(its worktree/clone was deleted), or it has no metadata. Folders whose source
still exists are **kept**. Session/editor state is never consulted.

DerivedData is a regenerable build cache — the worst case after pruning is one
slower rebuild.

## Safety

- Dry-run by default; `--apply` is required to change anything.
- Only ever moves to the **Trash** — nothing is hard-deleted.
- Rescans live on every run; never trusts a saved list.
- Only matches Xcode's `Name-<28-char hash>` folders, so shared caches
  (`ModuleCache.noindex`, `SymbolCache.noindex`, …) are never touched.
- Operates solely inside `~/Library/Developer/Xcode/DerivedData`.
