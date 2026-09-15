-- ~/.config/hypr/keybinds.lua
-- Based on 43PR/dotfiles, adapted for len's system.
-- User's original keybinds are KEPT; non-conflicting extras from 43PR are added.
-- Docs: https://wiki.hypr.land/Configuring/Basics/Binds/

local home = os.getenv("HOME")

-- ============ LAUNCHERS ============
-- User: SUPER+Q = terminal, SUPER+R = menu, SUPER+E = file manager
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))          -- alacritty (user)
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))              -- rofi (user, was wofi)
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))       -- thunar (user)
-- 43PR extras (non-conflicting)
-- hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))          -- terminal (43PR)
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))              -- app launcher (43PR)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))           -- firefox (43PR)

-- ============ WINDOW MANAGEMENT ============
-- User: SUPER+C = close, SUPER+M = exit, SUPER+G = toggle float, SUPER+F = fullscreen
hl.bind(mainMod .. " + C", hl.dsp.window.close())              -- close (user)
hl.bind(mainMod .. " + M", hl.dsp.exit())                      -- exit (user)
hl.bind(mainMod .. " + G", hl.dsp.window.float({ action = "toggle" })) -- float (user)
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = 0 }))      -- fullscreen (user)
-- User: SUPER+P = pin/unpin window (ngikut terus di semua workspace).
-- pin is floating-only: a tiled window is silently refused, so float it first.
hl.bind(mainMod .. " + P", function()
    local w = hl.get_active_window()
    if w == nil then return end
    if not w.floating then
        hl.dispatch(hl.dsp.window.float({ action = "toggle", window = "address:" .. w.address }))
    end
    hl.dispatch(hl.dsp.window.pin({ window = "address:" .. w.address }))
end)
-- 43PR extras: SUPER+Escape = wlogout, SUPER+Tab = lock, SUPER+SHIFT+E = exit
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("wlogout -b 1 -c 20 -r 20 -L 1700 -R 1700 -T 325 -B 325"))
hl.bind("SUPER + Tab", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
-- 43PR: SUPER+Space = toggle float + center + resize 60%
hl.bind(mainMod .. " + Space", function()
    hl.dispatch(hl.dsp.window.float({ action = "toggle" }))

    local w = hl.get_active_window()
    if w ~= nil and w.floating then
        local mon = hl.get_active_monitor()
        if mon ~= nil then
            local target_w = math.floor(mon.width * 0.6)
            local target_h = math.floor(mon.height * 0.6)

            hl.dispatch(hl.dsp.window.resize({ x = target_w, y = target_h, relative = false }))

            local mon_x = mon.x or 0
            local mon_y = mon.y or 0
            local target_x = mon_x + math.floor((mon.width - target_w) / 2)
            local target_y = mon_y + math.floor((mon.height - target_h) / 2)

            hl.dispatch(hl.dsp.window.move({ x = target_x, y = target_y, relative = false }))
        end
    end
end)

-- ============ SCREENSHOTS ============
-- User: PRINT = region -> swappy
hl.bind("PRINT", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
-- 43PR: SUPER+Delete = full screenshot, Delete = region screenshot
hl.bind(mainMod .. " + Delete", hl.dsp.exec_cmd("grim " .. home .. "/Pictures/$(date +%s).png"))
hl.bind("Delete", hl.dsp.exec_cmd('grim -g "$(slurp)" ' .. home .. '/Pictures/$(date +%s).png'))

-- ============ CLIPBOARD ============
-- User: SUPER+V = clipboard history with image thumbnails (rofi -show-icons)
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/cliphist-pick.sh"))

-- ============ WALLPAPER / OPACITY / WAYBAR ============
-- 43PR extras
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("quickshell -c hyprquickpaper"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/opacity.sh"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("sh -c 'pgrep -x waybar >/dev/null && pkill waybar || nohup waybar >/dev/null 2>&1 &'"))

-- ============ KEYBOARD LAYOUT ============
-- 43PR extra: SUPER+Z = cycle layout
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("hyprctl switchxkblayout current next"))

-- ============ FOCUS (user HJKL + arrows) ============
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- 43PR extras: SUPER+SHIFT+HJKL = move window in layout
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- 43PR extras: SUPER+CTRL+HJKL = resize active window
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -40, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 40, y = 0 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -40 }), { repeating = true })
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 40 }), { repeating = true })

-- ============ WORKSPACES 1-10 (user 1-9, 43PR adds 0=10 + move) ============
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. i, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
-- workspace 10 via SUPER+0 (43PR convention)
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- ============ MOUSE ============
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ============ MEDIA / AUDIO / BRIGHTNESS ============
-- Volume (user: pamixer, bindel style = repeating)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"), { locked = true })

-- Brightness (user: brightnessctl, bindel style)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })

-- Media keys (43PR extra: playerctl)
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
