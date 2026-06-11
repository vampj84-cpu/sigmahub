--[[
    Kaitun Standalone — Build Script
    Concatenates dependency modules + Kaitun logic into a single file.

    Usage: lua build-kaitun.lua
    Output: dist/Kaitun.lua
]]

local Modules = {
    "modules/01-core.lua",
    "modules/02-world.lua",
    "modules/03-remotes.lua",
    "modules/04-combat.lua",
    "modules/05-stats.lua",
    "modules/06-enemy.lua",
    "modules/07-utility.lua",
    "modules/08-movement.lua",
    "modules/09-quest.lua",
    "modules/11o-remote-log.lua",
    "modules/11n-kaitun.lua",
}

local scriptDir = (... or ".") .. "/"
local outputPath = scriptDir .. "dist/Kaitun.lua"
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
