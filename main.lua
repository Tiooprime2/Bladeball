-- ╔══════════════════════════════════════════╗
-- ║     TIOO BLADE V1 — MAIN LOADER          ║
-- ║         by Tiooprime2 • Blade Ball       ║
-- ╚══════════════════════════════════════════╝

local BASE_URL = "https://raw.githubusercontent.com/Tiooprime2/Bladeball/main/"

local function Load(path)
    return loadstring(game:HttpGet(BASE_URL .. path))()
end

-- Load UI dulu, lalu features
Load("ui.lua")
Load("features.lua")
