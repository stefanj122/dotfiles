-- qs, hypridle, cliphist, gnome-keyring... pokreće ~/.config/hypr/hyprland/execs.lua
hl.on("hyprland.start", function()
    -- hl.exec_cmd("nm-applet") -- ii sidebar ima network
    -- hl.exec_cmd("sus-way.sh") -- toggle za hypridle: na startu bi ga ugasio (upstream ga već pokreće); SUPER+SHIFT+K pali Keep awake iz sidebara
    -- hl.exec_cmd("blueman-applet") -- ii sidebar ima bluetooth
    hl.exec_cmd("kdeconnectd")
    hl.exec_cmd("solaar")
end)

-- exec (svaki reload)
hl.on("config.reloaded", function()
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'")
end)
