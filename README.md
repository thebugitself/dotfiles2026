# dotfiles2026

Ini dotfiles Hyprland saya — Arch Linux, dual monitor, bar waybar, launcher rofi,
terminal kitty. Saya pakai sendiri tiap hari, jadi isinya config yang betul-betul
kepakai, bukan kumpulan hasil copas.

Saya taruh di sini supaya orang bisa lihat isi setup saya: keybind apa saja yang ada,
file apa yang mengatur apa, dan bagian mana yang perlu diganti kalau mau dipakai di
mesin lain. Kalau ada yang mau diambil, silakan ambil sepotong-sepotong — nggak harus
semuanya.

File sisa/backup (`.disabled`, `.save`, `.bak`, `.backup`, config wofi/foot/fuzzel yang
sudah saya tinggalkan) sengaja tidak saya masukkan ke sini.

## Isi

```
.config/
├── hypr/
│   ├── hyprland.lua        # entry config saya (monitor, env, autostart, animasi, layout)
│   ├── keybinds.lua        # semua keybind saya
│   ├── rules.lua           # window rule + layer rule (blur + animasi rofi)
│   ├── hyprlock.conf       # lock screen (jam, now-playing, kontrol playerctl)
│   ├── hyprpaper.conf      # sisa setup lama, sekarang wallpaper saya pakai awww
│   └── scripts/
│       ├── cliphist-pick.sh   # clipboard history rofi + thumbnail gambar
│       ├── opacity.sh         # menu opacity window (rofi)
│       ├── now-playing.sh     # teks now-playing untuk hyprlock/waybar
│       ├── password-cursor.sh # kursor berkedip di hyprlock
│       └── togglefloat.sh     # sisa eksperimen, tidak saya pakai lagi
├── waybar/                 # bar atas (workspaces + ikon app, cpu/gpu/ram/temp, mpris, dll)
├── rofi/                   # launcher (config.rasi + colors.rasi)
├── kitty/                  # terminal + kitten search/scroll_mark
├── wlogout/                # menu power (layout, style, ikon)
├── quickshell/hyprquickpaper/  # wallpaper picker (Quickshell/QML) — SUPER+W
├── dunst/                  # notifikasi
├── fish/                   # shell (config, prompt, auto-start Hyprland di tty1)
├── gtk-3.0/, gtk-4.0/      # tema GTK
└── starship.toml           # prompt starship
extras/
└── burp-iconfont/          # font ikon Burp Suite + script remap codepoint (lihat README-nya)
```

## Keybind saya

| Bind | Aksi |
|---|---|
| `SUPER + Q` | terminal (kitty) |
| `SUPER + R` / `SUPER + D` | launcher rofi |
| `SUPER + E` | file manager (thunar) |
| `SUPER + B` | browser (firefox) |
| `SUPER + C` | tutup window |
| `SUPER + M` | keluar Hyprland |
| `SUPER + V` | clipboard history (cliphist + rofi + thumbnail gambar) |
| `SUPER + W` | ganti wallpaper (quickshell hyprquickpaper) |
| `SUPER + O` | menu opacity window |
| `SUPER + L / H / J / K` | fokus window (hjkl) |
| `SUPER + SHIFT + HJKL` | pindah window |
| `SUPER + CTRL + HJKL` | resize window |
| `SUPER + 1..9 / 0` | workspace 1..10 |
| `SUPER + SHIFT + 1..9 / 0` | pindah window ke workspace |
| `SUPER + Space` | toggle float + center 60% |
| `SUPER + P` | pin/unpin window — window ngikut terus tiap pindah workspace (auto-float dulu; pin cuma jalan di window floating) |
| `SUPER + Tab` | lock (hyprlock) |
| `SUPER + Escape` | menu power (wlogout) |
| `SUPER + SHIFT + W` | restart waybar |
| `Print` | screenshot region → swappy |
| `SUPER + Delete` / `Delete` | screenshot full / region ke ~/Pictures |
| `XF86*` | volume (pamixer), brightness (brightnessctl), media (playerctl) |

## Yang perlu terpasang

```
hyprland waybar rofi kitty fish starship wlogout quickshell dunst awww hyprlock
cliphist wl-clipboard grim slurp swappy playerctl pamixer brightnessctl
thunar firefox jq ffmpeg
```

Font: **JetBrainsMono Nerd Font**. Ikon Burp di waybar pakai font tambahan (lihat
`extras/burp-iconfont/`).

> Catatan: `kitty/kitty.conf` meng-`include` tema hasil generate quickshell
> (`~/.local/state/quickshell/user/generated/terminal/kitty-theme.conf`). Kalau kamu
> tidak memakai project quickshell yang sama, hapus/komentari baris `include` itu.

## Cara pakai

```bash
git clone git@github.com:thebugitself/dotfiles2026.git
cd dotfiles2026
./install.sh            # backup config lama ke ~/.dotfiles-backup-<timestamp>, lalu copy
./install.sh --dry-run  # lihat dulu apa yang akan ditimpa
```

`install.sh` menyalin `.config/*` ke `~/.config/`, mengganti path `/home/len` menjadi
`$HOME` kamu, dan (opsional) memasang font ikon Burp. Setelah itu **restart Hyprland** —
config Lua tidak ter-reload penuh tanpa restart.

## Catatan teknis

- Config Hyprland saya pakai format **Lua** (`hyprland.lua` + `require("keybinds")` /
  `require("rules")`), bukan `hyprland.conf`.
- Animasi layer (rofi launcher + clipboard picker) saya atur di `rules.lua` lewat
  `layer_rule { animation = "popin 85%" }`, durasinya di `hyprland.lua`
  (`layersIn`/`layersOut`).
- Ikon clipboard di waybar: gambar tampil sebagai thumbnail di rofi (`rofi -show-icons` +
  escape `icon\x1f`), lihat `cliphist-pick.sh`.
- Pin window (`SUPER + P`) cuma berlaku untuk window floating — ini batasan Hyprland,
  bukan setelan saya. Karena itu bind-nya men-float window otomatis sebelum pin.
