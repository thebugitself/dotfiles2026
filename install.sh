#!/usr/bin/env bash
# install.sh — pasang dotfiles2026 ke ~/.config
#   ./install.sh            backup lalu pasang
#   ./install.sh --dry-run  lihat rencana saja
#   ./install.sh --no-backup
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="$HOME/.config"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.dotfiles-backup-$STAMP"
DRYRUN=0
BACKUP_ON=1

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRYRUN=1 ;;
    --no-backup) BACKUP_ON=0 ;;
    -h|--help) sed -n '2,7p' "$0"; exit 0 ;;
    *) echo "argumen tidak dikenal: $arg"; exit 1 ;;
  esac
done

log() { printf '%s\n' "$*"; }

log "== dotfiles2026 → $DEST"
[ "$DRYRUN" = 1 ] && log "(dry-run: tidak ada file yang ditulis)"

# --- 1. backup config yang akan ditimpa -----------------------------------
if [ "$BACKUP_ON" = 1 ] && [ "$DRYRUN" = 0 ]; then
  mkdir -p "$BACKUP"
  ( cd "$REPO/.config" && find . -type f ) | while read -r rel; do
    tgt="$DEST/${rel#./}"
    if [ -e "$tgt" ]; then
      mkdir -p "$BACKUP/$(dirname "${rel#./}")"
      cp -a "$tgt" "$BACKUP/${rel#./}"
    fi
  done
  log "   backup lama → $BACKUP"
fi

# --- 2. copy + substitusi path --------------------------------------------
copied=0
while IFS= read -r rel; do
  rel="${rel#./}"
  src="$REPO/.config/$rel"
  tgt="$DEST/$rel"
  mkdir -p "$(dirname "$tgt")"

  case "$(file -b --mime-type "$src")" in
    text/*|application/json|application/xml|inode/x-empty)
      tmp="$(mktemp)"
      sed "s|/home/len|$HOME|g" "$src" > "$tmp"
      if [ "$DRYRUN" = 1 ]; then
        log "   [text] $rel"
      else
        install -m "$(stat -c %a "$src")" "$tmp" "$tgt"
      fi
      rm -f "$tmp"
      ;;
    *)
      if [ "$DRYRUN" = 1 ]; then
        log "   [bin ] $rel"
      else
        install -m "$(stat -c %a "$src")" "$src" "$tgt"
      fi
      ;;
  esac
  copied=$((copied+1))
done < <( cd "$REPO/.config" && find . -type f | sort )

log "   $copied file diproses"

# --- 3. font ikon Burp (opsional) -----------------------------------------
if [ -d "$REPO/extras/burp-iconfont" ]; then
  log "== font ikon Burp Suite"
  if [ "$DRYRUN" = 1 ]; then
    log "   (akan) pasang BurpSuite.ttf → ~/.local/share/fonts + fc-cache"
  else
    mkdir -p "$HOME/.local/share/burp-iconfont" "$HOME/.local/share/fonts"
    cp -a "$REPO/extras/burp-iconfont/BurpSuite-original.ttf" "$HOME/.local/share/burp-iconfont/" 2>/dev/null || true
    cp -a "$REPO/extras/burp-iconfont/remap-burp-font.py" "$HOME/.local/share/burp-iconfont/" 2>/dev/null || true
    if command -v uv >/dev/null 2>&1; then
      SRC_FONT="$HOME/.local/share/burp-iconfont/BurpSuite-original.ttf" \
      DST_FONT="$HOME/.local/share/fonts/BurpSuite.ttf" \
        uv run --quiet --with fonttools python "$REPO/extras/burp-iconfont/remap-burp-font.py" || true
      fc-cache -f >/dev/null 2>&1 || true
    else
      log "   (uv tidak ada — lewati remap font; font butuh codepoint U+EA00/EA01)"
    fi
  fi
fi

log
log "Selesai. Langkah berikutnya:"
log " 1. restart Hyprland (config Lua tidak reload penuh tanpa restart)"
log " 2. pastikan dependencies terpasang — lihat README.md"
