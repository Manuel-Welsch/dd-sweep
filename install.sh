#!/usr/bin/env bash
# Installer for dd-prune — copies the script into a directory on your PATH.
#
#   curl -fsSL https://raw.githubusercontent.com/Manuel-Welsch/dd-prune/main/install.sh | bash
#
# or, from a clone:   ./install.sh
#
# Override the destination with:  DD_PRUNE_BIN=~/.local/bin ./install.sh

set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/Manuel-Welsch/dd-prune/main/dd-prune"

choose_dir() {
  # Prefer an existing dir that's already on PATH; otherwise ~/bin.
  local d
  for d in "$HOME/bin" "$HOME/.local/bin"; do
    case ":$PATH:" in *":$d:"*) [ -d "$d" ] && { echo "$d"; return; } ;; esac
  done
  echo "$HOME/bin"
}

DEST="${DD_PRUNE_BIN:-$(choose_dir)}"
mkdir -p "$DEST"

# Use the copy next to this installer if present (clone), else download it.
SELF_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || echo .)"
if [ -f "$SELF_DIR/dd-prune" ]; then
  install -m 0755 "$SELF_DIR/dd-prune" "$DEST/dd-prune"
  echo "Installed from local copy."
else
  curl -fsSL "$REPO_RAW" -o "$DEST/dd-prune"
  chmod 0755 "$DEST/dd-prune"
  echo "Installed from $REPO_RAW"
fi

echo "  -> $DEST/dd-prune"
case ":$PATH:" in
  *":$DEST:"*) echo "Ready. Run:  dd-prune --help" ;;
  *)
    echo
    echo "NOTE: $DEST is not on your PATH. Add it to your shell rc, e.g.:"
    echo "  echo 'export PATH=\"$DEST:\$PATH\"' >> ~/.zshrc && source ~/.zshrc"
    ;;
esac
