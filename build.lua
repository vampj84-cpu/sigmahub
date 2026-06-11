--[[
    Sigma Hub v1.0 — Build Script
    Concatenates all module files into a single loadstring-compatible file.

    Usage: lua build.lua
    Output: dist/SigmaHub.lua
]]

local Modules = {
    "modules/_banner.lua",
    "modules/01-core.lua",
    "modules/02-world.lua",
    "modules/03-remotes.lua",
    "modules/04-combat.lua",
    "modules/05-stats.lua",
    "modules/06-enemy.lua",
    "modules/07-utility.lua",
    "modules/08-movement.lua",
    "modules/09-quest.lua",
    "modules/10-ui.lua",
    "modules/11a-main-features.lua",
    "modules/11b-settings.lua",
    "modules/11c-fishing.lua",
    "modules/11d-quests.lua",
    "modules/11e-race.lua",
    "modules/11f-prehistoric.lua",
    "modules/11g-sea-events.lua",
    "modules/11h-esp.lua",
    "modules/11i-raids.lua",
    "modules/11j-combat.lua",
    "modules/11k-travel.lua",
    "modules/11l-shop.lua",
    "modules/11m-misc.lua",
}

local scriptDir = (... or ".") .. "/"
local outputPath = scriptDir .. "dist/SigmaHub.lua"
local outputLines = {}

for _, modPath in ipairs(Modules) do
    local fullPath = scriptDir .. modPath
    local f, err = io.open(fullPath, "r")
    if not f then
        error("Failed to open " .. fullPath .. ": " .. tostring(err))
    end
    local content = f:read("*all")
    f:close()
    table.insert(outputLines, content)
    table.insert(outputLines, "\n")
end

local output = table.concat(outputLines)
local f, err = io.open(outputPath, "w")
if not f then
    error("Failed to write " .. outputPath .. ": " .. tostring(err))
end
f:write(output)
f:close()

print("Built " .. outputPath .. " (" .. #outputLines .. " modules, " .. #output .. " bytes)")
