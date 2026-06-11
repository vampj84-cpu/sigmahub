--[[
    Sigma Hub v1.0 — Modular Entry Point
    Loads all modules in dependency order for development.
    For Roblox distribution, use build.lua instead.
]]

local Modules = {
    "modules/_banner",
    "modules/01-core",
    "modules/02-world",
    "modules/03-remotes",
    "modules/04-combat",
    "modules/05-stats",
    "modules/06-enemy",
    "modules/07-utility",
    "modules/08-movement",
    "modules/09-quest",
    "modules/10-ui",
    "modules/11a-main-features",
    "modules/11b-settings",
    "modules/11c-fishing",
    "modules/11d-quests",
    "modules/11e-race",
    "modules/11f-prehistoric",
    "modules/11g-sea-events",
    "modules/11h-esp",
    "modules/11i-raids",
    "modules/11j-combat",
    "modules/11k-travel",
    "modules/11l-shop",
    "modules/11m-misc",
}

for _, modPath in ipairs(Modules) do
    local fullPath = modPath .. ".lua"
    local f, err = loadfile(fullPath)
    if not f then
        error("Failed to load " .. fullPath .. ": " .. tostring(err))
    end
    f()
end

print("Sigma Hub loaded successfully!")
