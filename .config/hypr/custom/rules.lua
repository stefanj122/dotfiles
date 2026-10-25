hl.window_rule({ name = "opacity-brave",   match = { class = "Brave.*" },   opacity = "1 override" })
hl.window_rule({ name = "opacity-firefox", match = { class = "firefox.*" }, opacity = "1 override" })
hl.window_rule({ name = "opacity-chrome",  match = { class = "chrome.*" },  opacity = "1 override" })
hl.window_rule({ name = "opacity-zen",     match = { class = "zen.*" },     opacity = "1 override" })
hl.window_rule({ name = "opacity-kitty",   match = { class = "kitty" },     opacity = "0.9 override" })

-- "Smart gaps" / "No gaps when only"
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })

hl.window_rule({
    name  = "no-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },

    border_size = 0,
    rounding    = 0,
})

hl.window_rule({
    name  = "no-gaps-f1",
    match = { float = false, workspace = "f[1]" },

    border_size = 0,
    rounding    = 0,
})

hl.window_rule({
    name  = "xwaylandvideobridge",
    match = { class = "^(xwaylandvideobridge)$" },

    opacity = "1.0 override",
})
