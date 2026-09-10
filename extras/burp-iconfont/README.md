# Font ikon Burp Suite di waybar

Agar ikon Burp muncul di tombol workspace waybar (bukan kotak / ikon terminal).

Sumber font: [noam09/fontcustom-burp-suite](https://github.com/noam09/fontcustom-burp-suite) (MIT).
File asli `BurpSuite-original.ttf` disalin ke repo ini.

## Kenapa perlu di-remap

Font upstream menaruh glyph di **U+F100 / U+F101**, dan codepoint itu **bentrok dengan Nerd Fonts v3**
(di JetBrainsMono Nerd Font: `U+F100 = fa-angles_left`, `U+F101 = fa-angles_right`). Akibatnya Pango
menampilkan glyph Nerd Font («») alih-alih logo Burp. Karena itu script ini menambah alias di
**U+EA00 (outline)** dan **U+EA01 (filled)** — PUA yang tidak dipakai font lain di sistem.

## Pasang

```bash
mkdir -p ~/.local/share/burp-iconfont ~/.local/share/fonts
cp BurpSuite-original.ttf ~/.local/share/burp-iconfont/
SRC_FONT=~/.local/share/burp-iconfont/BurpSuite-original.ttf \
DST_FONT=~/.local/share/fonts/BurpSuite.ttf \
  uv run --with fonttools python remap-burp-font.py
fc-cache -f
```

## Pakai di waybar

`.config/waybar/config.jsonc`:

```jsonc
"hyprland/workspaces": {
    "window-rewrite": {
        "class<burp": "\uEA01"   // logo Burp; U+EA00 = versi outline (lebih tipis)
    }
}
```

Catatan:
- Class window Burp Suite Professional = `burp-StartBurp`, jadi rule ditulis `class<burp`
  (pattern-nya regex `icase` dan di-`search`, jadi prefix tanpa `>` menangkap semua varian).
- Di font-size 11px versi outline (`U+EA00`) stroknya tipis 1px, versi filled (`U+EA01`) lebih tebal
  tapi celah logonya sempit. Kalau ingin logo lebih jelas: naikkan `font-size` tombol workspace.
- Kalau nanti unduh ulang font upstream, jalankan lagi `remap-burp-font.py`.
