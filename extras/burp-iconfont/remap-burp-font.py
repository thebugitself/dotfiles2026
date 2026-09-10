#!/usr/bin/env python3
"""Remap glyph Burp Suite icon-font ke codepoint PUA bebas.

Font upstream (noam09/fontcustom-burp-suite) menaruh glyph di U+F100/U+F101 —
bentrok dengan Nerd Fonts v3 (JetBrainsMono: U+F100 = fa-angles_left,
U+F101 = fa-angles_right), sehingga Pango menampilkan glyph Nerd Font, bukan
logo Burp. Script ini menambah alias U+EA00/U+EA01 (PUA bebas di sistem umum)
supaya fallback font sistem menemukan glyph Burp.

Pakai:
    # default path Arch
    uv run --with fonttools python remap-burp-font.py

    # path custom
    SRC_FONT=/path/BurpSuite-original.ttf DST_FONT=/path/BurpSuite.ttf \
        uv run --with fonttools python remap-burp-font.py
"""
import os
from fontTools.ttLib import TTFont

SRC = os.environ.get("SRC_FONT", os.path.expanduser("~/.local/share/burp-iconfont/BurpSuite-original.ttf"))
DST = os.environ.get("DST_FONT", os.path.expanduser("~/.local/share/fonts/BurpSuite.ttf"))

# codepoint lama -> (codepoint baru, nama glyph)
REMAP = {
    0xF100: (0xEA00, "icons8-burp-suite-1"),   # logo outline (paling kebaca di font kecil)
    0xF101: (0xEA01, "icons8-burp-suite-2"),   # logo filled
}


def main():
    font = TTFont(SRC)
    changed = 0
    for table in font["cmap"].tables:
        if not table.isUnicode():
            continue
        for old, (new, glyph) in REMAP.items():
            if table.cmap.get(old) == glyph:
                table.cmap[new] = glyph
                changed += 1
    os.makedirs(os.path.dirname(DST), exist_ok=True)
    font.save(DST)
    print(f"patched {changed} cmap entries -> {DST}")

    check = TTFont(DST).getBestCmap()
    for old, (new, glyph) in REMAP.items():
        print(f"  U+{new:04X} -> {check.get(new)}   (asli U+{old:04X} -> {check.get(old)})")


if __name__ == "__main__":
    main()
