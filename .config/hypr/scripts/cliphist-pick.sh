#!/usr/bin/env bash
# cliphist picker with image thumbnails (rofi dmenu -show-icons)
#
#   entries are fed as: "<label>\t<id>"  (+ extras after NUL)
#     display\x1f -> clean row text           (search still uses label+id)
#     icon\x1f    -> path to cached thumbnail (rofi 2.0 loads absolute paths)
#   rofi prints the entry back (label<TAB>id), so the id travels with the line.
#
# usage: cliphist-pick.sh [--dump] [max_entries]
set -uo pipefail

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/cliphist-thumbs"
LIMIT=400
DUMP=0

for arg in "$@"; do
  case "$arg" in
    --dump) DUMP=1 ;;
    *[!0-9]*) ;;
    *) LIMIT="$arg" ;;
  esac
done

mkdir -p "$CACHE"

# --- prune thumbnails whose entry is gone from the history ------------------
cliphist list | cut -f1 | sort -u >"$CACHE/.live.$$"
for f in "$CACHE"/*; do
  [[ -f $f ]] || continue
  case "${f##*/}" in .live.*) continue ;; esac
  id="${f##*/}"; id="${id%%.*}"
  grep -qx "$id" "$CACHE/.live.$$" || rm -f "$f"
done
rm -f "$CACHE/.live.$$"

# --- build rofi entries ----------------------------------------------------
build() {
  cliphist list | head -n "$LIMIT" | while IFS=$'\t' read -r id preview; do
    [[ -n ${id:-} ]] || continue

    if [[ $preview =~ ^\[\[[[:space:]]binary[[:space:]]data[[:space:]].*[[:space:]]([a-zA-Z0-9]+)[[:space:]]([0-9]+x[0-9]+)[[:space:]]\]\]$ ]]; then
      fmt="${BASH_REMATCH[1],,}"
      [[ $fmt == jpg ]] && fmt=jpeg
      dim="${BASH_REMATCH[2]}"
      thumb="$CACHE/$id.$fmt"
      if [[ ! -s $thumb ]]; then
        if cliphist decode "$id" >"$thumb.part" 2>/dev/null && [[ -s $thumb.part ]]; then
          mv -f "$thumb.part" "$thumb"
        else
          rm -f "$thumb.part"
          continue
        fi
      fi
      label="🖼  $dim  $fmt"
      printf '%s\t%s\0display\x1f%s\x1ficon\x1f%s\n' "$label" "$id" "$label" "$thumb"
    else
      label="${preview//[$'\t\r\n']/ }"
      ((${#label} > 160)) && label="${label:0:160}…"
      printf '%s\t%s\0display\x1f%s\n' "$label" "$id" "$label"
    fi
  done
}

if ((DUMP)); then
  build
  exit 0
fi

ENTS="$(mktemp)"
trap 'rm -f "$ENTS"' EXIT
build >"$ENTS"

if [[ ! -s $ENTS ]]; then
  notify-send -a clipboard "cliphist" "history kosong" 2>/dev/null
  exit 0
fi

# rofi may be driven non-interactively for testing / preselect:
#   CLIPHIST_PICK_FILTER='936x493' -> filter + auto-select the unique match
cmd=(rofi -dmenu -i -p "" -show-icons -no-sort \
  -input "$ENTS" \
  -theme-str 'element-icon { size: 48px; } listview { lines: 10; columns: 1; }' \
  -matching fuzzy)
[[ -n ${CLIPHIST_PICK_FILTER:-} ]] && cmd+=(-filter "$CLIPHIST_PICK_FILTER" -auto-select)

sel="$("${cmd[@]}")" || exit 0

[[ -n ${sel:-} ]] || exit 0
id="${sel##*$'\t'}"    # id is the last tab-separated field
[[ $id =~ ^[0-9]+$ ]] || exit 0

thumb="$(find "$CACHE" -maxdepth 1 -name "$id.*" -print -quit 2>/dev/null)"
if [[ -n ${thumb:-} ]]; then
  cliphist decode "$id" | wl-copy --type "image/${thumb##*.}"
else
  cliphist decode "$id" | wl-copy
fi
