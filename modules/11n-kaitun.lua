-- ============================================
-- MODULE 11n: Kaitun Mode — Master Controller
-- Auto-everything intelligence system
-- ============================================

-- Extend namecall hook to cover Kaitun mode
pcall(function()
    local gg = getrawmetatable(game)
    local old = gg.__namecall
    setreadonly(gg, false)
    gg.__namecall = newcclosure(function(...)
        local method = getnamecallmethod()
        local args = {...}
        if tostring(method) == "FireServer" then
            if tostring(args[1]) == "RemoteEvent" then
                if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                    if _G.KaitunMode then
                        args[2] = MousePos
                        return old(unpack(args))
                    end
                end
            end
        end
        return old(...)
    end)
end)

-- No Animation blocker
local function BlockAnimations()
    pcall(function()
        local char = plr.Character
        if not char then return end
        local humanoid = char:FindFirstChild("Humanoid")
        if not humanoid then return end
        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
            track:Stop()
        end
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if _G.KaitunMode and humanoid.Health > 0 then
                for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                    track:Stop()
                end
            end
        end)
        humanoid.AnimationPlayed:Connect(function(track)
            if _G.KaitunMode then
                task.spawn(function() track:Stop() end)
            end
        end)
    end)
end

plr.CharacterAdded:Connect(BlockAnimations)
BlockAnimations()

-- Fighting style mastery auto-upgrade
local function AutoFightingStyle()
    if not _G.KaitunMode then return end
    pcall(function()
        local remote = replicated.Remotes.CommF_
        if plr.Backpack:FindFirstChild("Combat") or plr.Character:FindFirstChild("Combat") then
            remote:InvokeServer("BuyBlackLeg")
        end
        local styles = {"Black Leg", "Electro", "Fishman Karate", "Dragon Claw"}
        local nextStyles = {"BuyElectro", "BuyFishmanKarate", "BlackbeardReward", "BuySuperhuman"}
        for i, style in ipairs(styles) do
            local bp = plr.Backpack:FindFirstChild(style)
            local ch = plr.Character:FindFirstChild(style)
            local level = (bp or ch)
            if level and level:FindFirstChild("Level") then
                if level.Level.Value >= 300 then
                    local ns = nextStyles[i]
                    if ns == "BlackbeardReward" then
                        remote:InvokeServer(ns, "DragonClaw", "2")
                    else
                        remote:InvokeServer(ns)
                    end
                end
            end
        end
    end)
end

-- Kaitun main controller loop
task.spawn(function()
    while task.wait(3) do
        if _G.KaitunMode then
            pcall(function()
                AutoFightingStyle()
                if _G.AutoStats == nil then _G.AutoStats = true end
            end)
        end
    end
end)

-- Smart weapon selection for Kaitun mode
task.spawn(function()
    while task.wait(2) do
        if _G.KaitunMode then
            pcall(function()
                local priority = {"Superhuman", "God Human", "Dragon Claw", "Fishman Karate", "Electro", "Black Leg", "Death Step", "Sharkman Karate", "Electric Claw"}
                for _, wpn in ipairs(priority) do
                    if plr.Backpack:FindFirstChild(wpn) then
                        _G.SelectWeapon = wpn
                        _G.ChooseWP = "Melee"
                        break
                    end
                end
            end)
        end
    end
end)
