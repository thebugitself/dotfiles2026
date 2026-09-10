-- ~/.config/hypr/rules.lua
-- Based on 43PR/dotfiles, adapted for len's system.
-- Window opacity + float rules. The opacity.sh script edits the value below.

local window_opacity = 1.0

-- Layer rules (blur + popin transition for rofi: launcher + clipboard picker)
hl.layer_rule({
    match = { namespace = "rofi" },
    blur = true,
    ignore_alpha = 0.15,
    animation = "popin 85%",
})

-- Opacity rule for regular apps (user apps + 43PR apps)
hl.window_rule({
    name = "opacity-apps",
    match = {
        class = "^(kitty|alacritty|xed|thunar|firefox|discord|codium|GeForceNOW|obsidian|Spotify|org.pulseaudio.pavucontrol|com.github.johnfactotum.Foliate)$",
    },
    opacity = window_opacity .. " override " .. window_opacity .. " override 1.0 override",
})

-- Float rules
hl.window_rule({
    name = "float-pavucontrol",
    match = { class = "^(pavucontrol)$" },
    float = true,
})

hl.window_rule({
    name = "float-nm-connection-editor",
    match = { class = "^(nm-connection-editor)$" },
    float = true,
})

hl.window_rule({
    name = "float-blueman-manager",
    match = { class = "^(blueman-manager)$" },
    float = true,
})

hl.window_rule({
    name = "float-open-file",
    match = { title = "^(Open File)$" },
    float = true,
})

hl.window_rule({
    name = "float-save-file",
    match = { title = "^(Save File)$" },
    float = true,
})
