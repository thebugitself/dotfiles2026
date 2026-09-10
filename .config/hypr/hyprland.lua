-- ~/.config/hypr/hyprland.lua
-- Based on 43PR/dotfiles (https://github.com/43PR/dotfiles), adapted for len's system.
-- Docs: https://wiki.hypr.land/Configuring/Start/

-- MONITORS
-- Dual monitor: explicit 1920x1080 on both displays
hl.monitor({ output = "eDP-1", mode = "1920x1080@144", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "1920x0", scale = 1 })

---- ENVIRONMENT VARIABLES (kept from previous config - NVIDIA hybrid laptop) ----
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("GTK_THEME", "Adwaita:dark")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("NVD_BACKEND", "direct")
hl.env("AQ_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card1")
hl.env("WLR_DRM_DEVICES", "/dev/dri/card2:/dev/dri/card1")
hl.env("XCURSOR_SIZE", "18")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("MOZ_ENABLE_WAYLAND", "1")

---- MY PROGRAMS ----
-- Keep the user's existing apps (keybinds stay the same)
mainMod    = "SUPER"
terminal   = "kitty"
menu       = "rofi -show drun"
fileManager = "thunar"
browser    = "firefox"

---- AUTOSTART ----
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    hl.exec_cmd("mkdir -p /home/len/.cache/awww && awww-daemon")
    hl.exec_cmd("sleep 2 && awww img /home/len/Wallpapers/2.jpg")
end)

---- INPUT ----
hl.config({
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0.5,
        touchpad = {
            natural_scroll = true, -- keep user preference
            tap_to_click = true,
        },
    },
})

---- LOOK AND FEEL ----
hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 5,
        border_size = 0,
        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 8,
        blur = {
            enabled = true,
            size = 5,
            passes = 1,
            vibrancy = 0.2,
        },
        shadow = {
            enabled = true,
            range = 12,
            render_power = 3,
        },
    },
    animations = {
        enabled = true,
    },
})

-- Old: bezier = easeOut,0.05,0.9,0.1,1.0
hl.curve("easeOut", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.0} } })
hl.curve("snappy", { type = "bezier", points = { {0.05, 0.7}, {0.1, 1.0} } })

-- Old: animation = windows,1,5,easeOut  (enabled, speed, style)
-- Animations enabled - fastest speed (100ms)
hl.animation({ leaf = "windows",    enabled = true, speed = 1, bezier = "snappy" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "snappy" })
hl.animation({ leaf = "border",     enabled = true, speed = 1, bezier = "easeOut" })
hl.animation({ leaf = "fade",       enabled = true, speed = 1, bezier = "easeOut" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1, bezier = "snappy" })

-- Layer transition (rofi launcher + clipboard picker): popin scale-up, 200ms
hl.animation({ leaf = "layersIn",  enabled = true, speed = 2, bezier = "snappy" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2, bezier = "snappy" })

-- LAYOUT
hl.config({
    dwindle = { preserve_split = true },
})
hl.config({
    master = { new_status = "master" },
})

-- MISC
hl.config({
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
})


---- SPLIT-OUT FILES ----
require("keybinds")
require("rules")
