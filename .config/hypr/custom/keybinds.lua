hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

-- Moje prečice. Učitava se posle ~/.config/hypr/hyprland/keybinds.lua, pa prvo
-- uklanjam upstream bind na istom tasteru (inače bi se oba izvršila).
local function rebind(key, action, opts)
    hl.unbind(key)
    hl.bind(key, action, opts)
end

local mainMod = "SUPER"

-- Touchpad on/off
-- `hyprctl keyword` ne radi sa lua parserom, pa se device menja direktno
-- preko hl.device (izvan Hyprlanda: `hyprctl eval "hl.device{...}"`).
local TOUCHPAD = "ven_04f3:00-04f3:32aa-touchpad"

rebind(mainMod .. " + T",         function() hl.device({ name = TOUCHPAD, enabled = false }) end, { description = "Touchpad: Off" })
rebind(mainMod .. " + SHIFT + T", function() hl.device({ name = TOUCHPAD, enabled = true }) end,  { description = "Touchpad: On" })

rebind(mainMod .. " + SHIFT + Return", hl.dsp.exec_cmd(tmux),        { description = "App: Terminal (tmux)" })
rebind(mainMod .. " + SHIFT + Q",      hl.dsp.global("quickshell:sessionToggle"), { description = "Shell: Toggle session menu" })
rebind(mainMod .. " + SHIFT + E",      hl.dsp.exit())
rebind(mainMod .. " + V",              hl.dsp.window.float({ action = "toggle" }), { description = "Window: Float/Tile" })
rebind(mainMod .. " + P",              hl.dsp.exec_cmd(screenshot),  { description = "Utilities: Screenshot region >> swappy" })
rebind(mainMod .. " + SHIFT + P",      hl.dsp.exec_cmd(imgToText),   { description = "Utilities: OCR >> clipboard" })
rebind(mainMod .. " + M",              hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }), { description = "Window: Maximize" })
rebind(mainMod .. " + C",              hl.dsp.global("quickshell:overviewClipboardToggle"), { description = "Utilities: Clipboard history" })
rebind(mainMod .. " + D",              hl.dsp.exec_cmd("clip_util.sh"))
rebind("ALT + CTRL + P",               hl.dsp.global("quickshell:overviewPassToggle"), { description = "Utilities: Password store (pass)" })
rebind("ALT + B",                      hl.dsp.exec_cmd("zen-browser"))
rebind("ALT + T",                      hl.dsp.exec_cmd("thunderbird"))
-- ALT + SHIFT je prebacivanje layout-a (grp:alt_shift_toggle), pa keep awake ide na SUPER + SHIFT + K
rebind(mainMod .. " + SHIFT + K",      hl.dsp.global("quickshell:idleInhibitToggle"), { description = "Shell: Toggle keep awake" })
-- SUPER + N ostaje upstream (desni sidebar sa notifikacijama); rofi_notifications traži dunst.

-- Move focus
rebind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
rebind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
rebind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
rebind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))

-- Workspaces (split-monitor-workspaces plugin).
-- Upstream vezuje SUPER / SUPER+ALT + 1..0 (i keycode / numpad varijante) na
-- globalne workspace ID-jeve, što se tuče sa pluginom -- sve to uklanjam.
for i = 0, 9 do
    hl.unbind(mainMod .. " + " .. i)
    hl.unbind(mainMod .. " + ALT + " .. i)
end
for _, code in ipairs({ 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }) do
    hl.unbind(mainMod .. " + code:" .. code)
    hl.unbind(mainMod .. " + ALT + code:" .. code)
end
for i = 1, 5 do
    hl.bind(mainMod .. " + " .. i, function()
        return hl.plugin[SMW_API].workspace(i)
    end, { description = "Workspace: Focus " .. i })
    hl.bind(mainMod .. " + SHIFT + " .. i, function()
        return hl.plugin[SMW_API].move_to_workspace_silent(i)
    end, { description = "Window: Send to workspace " .. i })
end

rebind(mainMod .. " + grave",         hl.dsp.focus({ monitor = "+1" }), { description = "Monitor: Focus next" })
rebind(mainMod .. " + SHIFT + grave", function()
    return hl.plugin[SMW_API].change_monitor("+1")
end, { description = "Window: Move to next monitor" })

-- Minimize / restore
rebind(mainMod .. " + X", function()
    if hl.get_workspace("special:minimized") then
        hl.dispatch(hl.dsp.window.move({ workspace = hl.get_active_workspace(), window = "tag:minimized" }))
        hl.dispatch(hl.dsp.window.clear_tags({ window = "tag:minimized" }))
    else
        hl.dispatch(hl.dsp.window.tag({ tag = "minimized", window = hl.get_active_window() }))
        hl.dispatch(hl.dsp.window.move({ workspace = "special:minimized", follow = false }))
    end
end, { description = "Window: Minimize/restore" })

-- Hide / unhide window (scratchpad zamena)
rebind(mainMod .. " + S",         hl.dsp.exec_cmd("~/.scripts/hide_unhide_window.sh h"), { description = "Window: Hide" })
rebind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("~/.scripts/hide_unhide_window.sh s"), { description = "Window: Unhide" })

-- Scroll through existing workspaces with mainMod + scroll
rebind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
rebind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Volume / brightness (press and hold)
rebind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 3%+"), { locked = true, repeating = true })
rebind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-"),      { locked = true, repeating = true })
rebind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true })
rebind("XF86MonBrightnessUp",   hl.dsp.global("quickshell:brightnessIncrease"), { locked = true, repeating = true })
rebind("XF86MonBrightnessDown", hl.dsp.global("quickshell:brightnessDecrease"), { locked = true, repeating = true })

-- Media keys (rade i kad je ekran zaključan)
local mpris = "dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player."
rebind("XF86AudioPlay", hl.dsp.exec_cmd(mpris .. "PlayPause"), { locked = true })
rebind("XF86AudioNext", hl.dsp.exec_cmd(mpris .. "Next"),      { locked = true })
rebind("XF86AudioPrev", hl.dsp.exec_cmd(mpris .. "Previous"),  { locked = true })

rebind("Print", hl.dsp.global("quickshell:regionScreenshot"), { description = "Utilities: Screen snip" })
