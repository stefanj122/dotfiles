# neofetch
starship init fish | source
fzf --fish | source
bind -M insert \cy accept-autosuggestion
bind -M insert \ck complete-and-search
bind -M insert \cj complete
bind -M insert \cp history-search-backward
bind -M insert \cn history-search-forward
direnv hook fish | source
