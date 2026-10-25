------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto-left",
    scale    = 1,
})

-----------------
---- PLUGINI ----
-----------------

-- `hyprctl keyword` ne radi sa lua parserom ("keyword can't work with non-legacy
-- parsers"), pa se plugin učitava odavde preko hl.plugin.load.
--
-- VAŽNO: hl.plugin.load je ODLOŽEN -- ne vraća ništa, ne baca grešku (ni za
-- nepostojeći .so) i plugin JOŠ NIJE učitan dok se ostatak fajla parsira.
-- Zato plugin config keys ne postoje u toku parsiranja i moraju se postaviti
-- kasnije, iz hyprland.start.
--
-- .so gradi i održava hyprpm (`hyprpm update` posle update-a Hyprlanda).
-- Putanja je /var/cache/hyprpm/$USER/... -- ~/.local/share/hyprpm je stara
-- lokacija iz starijih hyprpm verzija i tamo stoji zastareo .so.
SMW_NAME = "split-monitor-workspaces"
SMW_API  = "split_monitor_workspaces"
local SMW_SO = "/var/cache/hyprpm/" .. (os.getenv("USER") or "") .. "/" .. SMW_NAME .. "/" .. SMW_NAME .. ".so"

hl.plugin.load(SMW_SO)

local function configure_smw()
    if hl.plugin[SMW_API] == nil then
        return
    end

    hl.config({
        plugin = {
            [SMW_API] = {
                count                        = 5,
                keep_focused                 = false,
                enable_notifications         = false,
                enable_persistent_workspaces = true,
            },
        },
    })
end

-- The plugin forces a config reload after loading. On that second pass its Lua
-- namespace exists, so the workspace count is applied before monitors are mapped.
configure_smw()
hl.on("hyprland.start", function()
    configure_smw()
end)

--------------------
---- LAYOUT ----
--------------------

-- Novi prozor na workspace-u sa maksimizovanim/fullscreen prozorom: 1 = stari izađe iz
-- maximize-a i novi se otvori normalno. Upstream ima 2, gde novi preuzme maximize.
hl.config({
    misc = {
        on_focus_under_fullscreen = 1,
    },
})

hl.config({
    general = {
        layout = "master",
    },
    master = {
        new_on_top = false,
        new_status = "slave",
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us,rs",
        kb_variant = ",latin",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle,caps:escape", -- Caps Lock = Esc
        kb_rules   = "",

        sensitivity = -0.3, -- -1.0 - 1.0, 0 means no modification.
    },
})

-- Per-device config
hl.device({
    name          = "kingston-hyperx-pulsefire-haste-1",
    sensitivity   = -0.3,
    accel_profile = "flat",
})

hl.device({
    name          = "kingston-hyperx-pulsefire-haste",
    sensitivity   = -0.3,
    accel_profile = "flat",
})

hl.device({
    name          = "logitech-mx-master-3s",
    sensitivity   = -0.3,
    accel_profile = "flat",
})

-- Isključen / ponovo priključen monitor
--
-- Kad se monitor isključi, prozori sa njegovih workspace-ova (npr. 6-10) ostanu
-- na workspace-ovima koji više ne pripadaju nijednom monitoru, pa se ne vide.
-- grab_rogue_windows ih prebaci na trenutni workspace laptopa. Pre toga se
-- zapamti gde je koji prozor bio (u fajl, da preživi i reload configa), pa se
-- kad se monitor ponovo priključi prozori vrate na svoje workspace-ove.
-- Timeri daju pluginu vremena da prvo obradi dodavanje/uklanjanje monitora.
local SMW_RESTORE_FILE = "/tmp/hypr-smw-restore-" .. (os.getenv("USER") or "user")

local function window_workspaces()
    local map = {}
    for _, w in ipairs(hl.get_windows()) do
        if w.workspace ~= nil and not w.workspace.special then
            map[w.address] = w.workspace.id
        end
    end
    return map
end

hl.on("monitor.removed", function()
    hl.timer(function()
        local smw = hl.plugin[SMW_API]
        if smw == nil or smw.grab_rogue_windows == nil then
            return
        end

        local before = window_workspaces()
        smw.grab_rogue_windows()
        local after = window_workspaces()

        -- Zapamti samo prozore koje je grab_rogue_windows pomerio
        local f = io.open(SMW_RESTORE_FILE, "a")
        if f == nil then
            return
        end
        for address, ws in pairs(before) do
            if after[address] ~= nil and after[address] ~= ws then
                f:write(address .. " " .. ws .. "\n")
            end
        end
        f:close()
    end, { timeout = 500, type = "oneshot" })
end)

hl.on("monitor.added", function()
    hl.timer(function()
        local f = io.open(SMW_RESTORE_FILE, "r")
        if f == nil then
            return
        end
        local saved = {}
        for line in f:lines() do
            local address, ws = line:match("^(%S+) (%d+)$")
            if address ~= nil then
                saved[address] = tonumber(ws)
            end
        end
        f:close()
        os.remove(SMW_RESTORE_FILE)

        local current = window_workspaces()
        for address, ws in pairs(saved) do
            -- Prozor još postoji i nije već na svom workspace-u
            if current[address] ~= nil and current[address] ~= ws then
                hl.dispatch(hl.dsp.window.move({ workspace = ws, window = "address:" .. address, follow = false }))
            end
        end
    end, { timeout = 1000, type = "oneshot" })
end)
