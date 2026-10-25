-- Moji programi (override za ~/.config/hypr/hyprland/variables.lua)
terminal    = "kitty -e zsh"
fileManager = "kitty -e yazi"
browser     = "zen-browser"

tmux        = "kitty -e tmux a"
screenshot  = "hyprshot --freeze -m region --raw | swappy -f -"
colorpicker = "hyprpicker | wl-copy"
imgToText   = "hyprshot --freeze -m region --raw | tesseract - - | wl-copy"

taskManager = "kitty -e btop"
