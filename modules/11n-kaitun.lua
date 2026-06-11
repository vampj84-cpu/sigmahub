-- ============================================
-- MODULE 11n: Kaitun Standalone
-- Self-contained auto-progression with GUI.
-- NameCall hook is handled by 06-enemy.lua
-- via _G.KaitunStandalone flag.
-- ============================================

_G.KaitunStandalone = true

-- Destroy Sigma Hub UI if present
pcall(function()
    for _, v in pairs(plr.PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name ~= "Main" and v.Name ~= "NotificationHolder" then
            v:Destroy()
        end
    end
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
        humanoid.AnimationPlayed:Connect(function(track)
            task.spawn(function() track:Stop() end)
        end)
    end)
end
plr.CharacterAdded:Connect(BlockAnimations)
BlockAnimations()

-- Fighting style progression
local function KaitunFightingStyle()
    local ok, err = pcall(function()
        local remote = replicated.Remotes.CommF_
        local lvl = plr.Data.Level.Value
        local function GetStyleLevel(name)
            local bp = plr.Backpack:FindFirstChild(name)
            local ch = plr.Character:FindFirstChild(name)
            local tool = bp or ch
            if tool and tool:FindFirstChild("Level") then
                return tool.Level.Value
            end
            return 0
        end

        local prio = {"God Human", "Sanguine Art", "Superhuman", "Dragon Talon", "Electric Claw", "Sharkman Karate", "Death Step", "Dragon Claw", "Fishman Karate", "Electro", "Black Leg", "Combat"}
        for _, s in ipairs(prio) do
            if plr.Backpack:FindFirstChild(s) then
                _G.SelectWeapon = s
                _G.ChooseWP = "Melee"
                break
            end
        end

        if not GetBP("Black Leg") and not GetBP("Electro") and not GetBP("Fishman Karate") and not GetBP("Dragon Claw") and not GetBP("Superhuman") then
            if lvl >= 1 then remote:InvokeServer("BuyBlackLeg"); RemoteLog:info("BlackLeg", "Bought Black Leg") end
            return
        end
        if GetBP("Black Leg") and not GetBP("Electro") and GetStyleLevel("Black Leg") >= 300 then
            remote:InvokeServer("BuyElectro"); RemoteLog:info("Electro", "Bought Electro"); return
        end
        if GetBP("Electro") and not GetBP("Fishman Karate") and GetStyleLevel("Electro") >= 300 then
            remote:InvokeServer("BuyFishmanKarate"); RemoteLog:info("FishmanKarate", "Bought Fishman Karate"); return
        end
        if GetBP("Fishman Karate") and not GetBP("Dragon Claw") and GetStyleLevel("Fishman Karate") >= 300 and lvl >= 850 then
            remote:InvokeServer("BlackbeardReward", "DragonClaw", "2"); RemoteLog:info("DragonClaw", "Bought Dragon Claw"); return
        end
        if GetBP("Dragon Claw") and not GetBP("Superhuman") and GetStyleLevel("Dragon Claw") >= 400 and lvl >= 1100 then
            remote:InvokeServer("BuySuperhuman"); RemoteLog:info("Superhuman", "Bought Superhuman"); return
        end
        if GetBP("Superhuman") and not GetBP("God Human") and GetStyleLevel("Superhuman") >= 400 and lvl >= 1500 then
            remote:InvokeServer("BuyGodhuman"); RemoteLog:info("GodHuman", "Bought God Human"); return
        end
        if GetBP("God Human") and not GetBP("Sanguine Art") and GetStyleLevel("God Human") >= 400 and lvl >= 2000 then
            remote:InvokeServer("BuySanguineArt"); RemoteLog:info("SanguineArt", "Bought Sanguine Art"); return
        end
    end)
    if not ok then RemoteLog:log("KaitunFightingStyle", err) end
end

-- Auto stats: Melee -> 2800 then Defense
local function KaitunAutoStats()
    local ok, err = pcall(function()
        if plr.Data.Points.Value > 0 then
            if plr.Data.Combat.Value < 2800 then
                replicated.Remotes.CommF_:InvokeServer("AddPoint", "Melee", plr.Data.Points.Value)
            else
                replicated.Remotes.CommF_:InvokeServer("AddPoint", "Defense", plr.Data.Points.Value)
            end
        end
    end)
    if not ok then RemoteLog:log("KaitunAutoStats", err) end
end

-- Sea progression
local function KaitunSeaProgression()
    local ok, err = pcall(function()
        local lvl = plr.Data.Level.Value
        local char = plr.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        if World1 and lvl >= 700 then
            RemoteLog:info("SeaTravel", "Traveling to Sea 2 (lvl " .. lvl .. ")")
            _tp(CFrame.new(-5089.962, 312.883, -3124.601))
            wait(1)
            replicated.Remotes.CommF_:InvokeServer("TravelMain")
            return
        end
        if World2 and lvl >= 1500 then
            RemoteLog:info("SeaTravel", "Traveling to Sea 3 (lvl " .. lvl .. ")")
            _tp(CFrame.new(-5089.962, 312.883, -3124.601))
            wait(1)
            replicated.Remotes.CommF_:InvokeServer("TravelMain")
            return
        end
        if World3 and lvl >= 2600 then
            local function IsInSubmerged()
                if not hrp then return false end
                local islandPos = Vector3.new(11520.8, 0, 9829.5)
                local playerXZ = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
                return (playerXZ - islandPos).Magnitude < 3000
            end
            if not IsInSubmerged() then
                RemoteLog:info("SeaTravel", "Traveling to Submerged Island (lvl " .. lvl .. ")")
                _tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955))
                wait(1)
                local ok2, err2 = pcall(function()
                    replicated.Modules.Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
                end)
                if not ok2 then RemoteLog:log("SubmergedTravel", err2) end
                wait(2)
            end
        end
    end)
    if not ok then RemoteLog:log("KaitunSeaProgression", err) end
end

-- Find mob by name
local function FindMob(mobName)
    for _, v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == mobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            return v
        end
    end
    for _, v in pairs(replicated:GetChildren()) do
        if v.Name == mobName and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            return v
        end
    end
    return nil
end

-- Teleport to enemy spawn area
local function GotoEnemySpawn(mobName)
    local spawns = workspace["_WorldOrigin"] and workspace["_WorldOrigin"]:FindFirstChild("EnemySpawns")
    if not spawns then return end
    for _, spawn in pairs(spawns:GetChildren()) do
        if string.find(spawn.Name, mobName) then
            _tp(spawn.CFrame * CFrame.new(0, 20, 0))
            return
        end
    end
end

-- ============================================
-- GUI
-- ============================================

local ac = Color3.fromRGB
local sg = Instance.new("ScreenGui")
sg.Name = "KaitunHub"
sg.ResetOnSpawn = false
sg.Parent = plr:WaitForChild("PlayerGui")

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 300, 0, 360)
f.Position = UDim2.new(0, 15, 0.5, -180)
f.BackgroundColor3 = ac(8, 8, 12)
f.BorderColor3 = ac(0, 180, 180)
f.Active = true
f.Draggable = true
f.Parent = sg

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 28)
title.BackgroundColor3 = ac(0, 150, 150)
title.Text = "  Kaitun Mode"
title.TextColor3 = ac(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = f

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -28, 0, 0)
close.BackgroundColor3 = ac(180, 40, 40)
close.Text = "X"
close.TextColor3 = ac(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.Parent = f
close.MouseButton1Click:Connect(function() sg:Destroy(); _G.KaitunStandalone = nil end)

local function makeLbl(parent, posY, text, color, size)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, size or 16)
    lbl.Position = UDim2.new(0, 5, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or ac(180, 180, 180)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local function makeBar(parent, posY, fillColor)
    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1, -10, 0, 10)
    bg.Position = UDim2.new(0, 5, 0, posY)
    bg.BackgroundColor3 = ac(20, 20, 30)
    bg.BorderSizePixel = 0
    bg.Parent = parent
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = fillColor or ac(0, 200, 200)
    fill.BorderSizePixel = 0
    fill.Parent = bg
    return fill
end

makeLbl(f, 32, "Level: 1 / 2800", ac(255, 255, 255))
local levelBarFill = makeBar(f, 50, ac(0, 200, 200))
makeLbl(f, 62, "Sea: 1 (First Sea)", nil)
makeLbl(f, 78, "Status: Starting...", ac(255, 200, 80))
makeLbl(f, 94, "Farming: --", nil)

local div = Instance.new("Frame")
div.Size = UDim2.new(1, -10, 0, 1)
div.Position = UDim2.new(0, 5, 0, 112)
div.BackgroundColor3 = ac(0, 150, 150)
div.BorderSizePixel = 0
div.Parent = f

makeLbl(f, 116, "Style: Combat", ac(0, 220, 180), 14)
local styleBarFill = makeBar(f, 132, ac(0, 220, 120))

makeLbl(f, 146, "Fighting Styles:", ac(0, 180, 180), 14)

local styleList = {}
local styleNames = {"Black Leg", "Electro", "Fishman Karate", "Dragon Claw", "Superhuman", "God Human", "Sanguine Art"}
for i, name in ipairs(styleNames) do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 16)
    lbl.Position = UDim2.new(0, 15, 0, 162 + (i - 1) * 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. name
    lbl.TextColor3 = ac(80, 80, 80)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = f
    styleList[name] = lbl
end

local footer = makeLbl(f, 162 + #styleNames * 16 + 6, "made by josiah", ac(70, 70, 70))
footer.TextXAlignment = Enum.TextXAlignment.Center
footer.Size = UDim2.new(1, 0, 0, 16)
footer.Position = UDim2.new(0, 0, 0, 162 + #styleNames * 16 + 6)

-- GUI update references
local levelLbl = f:FindFirstChild("TextLabel")
local seaLbl, statusText, farmLbl, styleLbl
for _, v in pairs(f:GetChildren()) do
    if v:IsA("TextLabel") then
        local t = v.Text
        if t:find("^Level:") then levelLbl = v
        elseif t:find("^Sea:") then seaLbl = v
        elseif t:find("^Status:") then statusText = v
        elseif t:find("^Farming:") then farmLbl = v
        elseif t:find("^Style:") then styleLbl = v
        end
    end
end

-- ============================================
-- Main farming loop
-- ============================================

task.spawn(function()
    local styleCheckTimer = 0
    local lastLevel = plr.Data.Level.Value
    local lastSea = ""
    while task.wait(0.3) do
        local farmOk, farmErr = pcall(function()
            local char = plr.Character or plr.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            if not hrp then return end

            -- Level up / sea change detection
            local curLevel = plr.Data.Level.Value
            if curLevel ~= lastLevel then
                RemoteLog:info("LevelUp", "Reached level " .. curLevel)
                lastLevel = curLevel
            end
            local curSea = (World1 and "Sea1" or World2 and "Sea2" or World3 and "Sea3" or "?")
            if curSea ~= lastSea then
                lastSea = curSea
            end

            KaitunSeaProgression()

            styleCheckTimer = styleCheckTimer + 1
            if styleCheckTimer >= 10 then
                styleCheckTimer = 0
                KaitunFightingStyle()
                KaitunAutoStats()
            end

            local questUI = plr.PlayerGui.Main.Quest
            local QuestTitle = questUI.Visible and questUI.Container.QuestTitle.Title.Text or ""

            local questData = QuestNeta()
            if not questData or not questData[1] then task.wait(1); return end

            local enemyName = questData[1]
            local questName = questData[3]
            local questId = questData[2]
            local questPos = questData[6]

            if questUI.Visible and not string.find(QuestTitle, enemyName) then
                replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                task.wait(0.3)
                return
            end

            if not questUI.Visible then
                if questPos then
                    if (hrp.Position - questPos.Position).Magnitude > 20 then
                        _tp(questPos)
                        task.wait(0.5)
                    end
                    if (hrp.Position - questPos.Position).Magnitude <= 30 then
                        replicated.Remotes.CommF_:InvokeServer("StartQuest", questName, questId)
                        RemoteLog:info("Quest", "Started quest: " .. questName .. " (" .. enemyName .. ")")
                    end
                else
                    replicated.Remotes.CommF_:InvokeServer("StartQuest", questName, questId)
                    RemoteLog:info("Quest", "Started quest: " .. questName .. " (" .. enemyName .. ")")
                end
                task.wait(0.5)
                return
            end

            local mob = FindMob(enemyName)
            if mob then
                repeat
                    task.wait(Sec)
                    if hrp and mob and mob:FindFirstChild("HumanoidRootPart") then
                        _tp(mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                        Attack.Kill(mob, true)
                    end
                until not mob.Parent or not mob:FindFirstChild("Humanoid") or mob.Humanoid.Health <= 0 or not questUI.Visible
            else
                GotoEnemySpawn(enemyName)
            end
        end)
        if not farmOk then RemoteLog:log("FarmLoop", farmErr) end
    end
end)

-- Auto-collect chests
task.spawn(function()
    while task.wait(2) do
        local ok, err = pcall(function()
            local char = plr.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local CollectionService = game:GetService("CollectionService")
            local chests = CollectionService:GetTagged("_ChestTagged")
            local nearest, nearDist = nil, math.huge
            for _, chest in ipairs(chests) do
                if not chest:GetAttribute("IsDisabled") then
                    local dist = (chest:GetPivot().Position - hrp.Position).Magnitude
                    if dist < nearDist and dist < 300 then
                        nearDist = dist
                        nearest = chest
                    end
                end
            end
            if nearest then
                _tp(nearest:GetPivot())
                task.wait(0.5)
            end
        end)
        if not ok then RemoteLog:log("ChestLoop", err) end
    end
end)

-- GUI update loop
task.spawn(function()
    local seaNames = {[1] = "1 (First Sea)", [2] = "2 (Second Sea)", [3] = "3 (Third Sea)"}
    local function GetStyleLevel(name)
        local bp = plr.Backpack:FindFirstChild(name)
        local ch = plr.Character:FindFirstChild(name)
        local tool = bp or ch
        if tool and tool:FindFirstChild("Level") then
            return tool.Level.Value
        end
        return 0
    end

    while task.wait(0.5) do
        local ok, err = pcall(function()
            local lvl = plr.Data.Level.Value
            local sea = (World1 and 1) or (World2 and 2) or (World3 and 3) or 1
            levelLbl.Text = "Level: " .. string.format("%d / 2800", lvl)
            levelBarFill:TweenSize(UDim2.new(lvl / 2800, 0, 1, 0), "Out", "Linear", 0.3, true)
            seaLbl.Text = "Sea: " .. (seaNames[sea] or "?")

            local questUI = plr.PlayerGui.Main.Quest
            if questUI.Visible then
                local title = questUI.Container.QuestTitle.Title.Text
                farmLbl.Text = "Farming: " .. title
                statusText.Text = "Status: Engaging enemy..."
                statusText.TextColor3 = ac(80, 230, 80)
            else
                farmLbl.Text = "Farming: Seeking quest..."
                statusText.Text = "Status: Traveling..."
                statusText.TextColor3 = ac(230, 180, 60)
            end

            local currentStyle = "None"
            local currentLevel = 0
            local styleChecks = {"God Human", "Sanguine Art", "Superhuman", "Dragon Talon", "Electric Claw", "Sharkman Karate", "Death Step", "Dragon Claw", "Fishman Karate", "Electro", "Black Leg", "Combat"}
            for _, s in ipairs(styleChecks) do
                local sl = GetStyleLevel(s)
                if sl > 0 then
                    currentStyle = s
                    currentLevel = sl
                    break
                end
            end
            if currentStyle ~= "None" then
                styleLbl.Text = "Style: " .. currentStyle .. " (" .. currentLevel .. "/400)"
                styleBarFill:TweenSize(UDim2.new(currentLevel / 400, 0, 1, 0), "Out", "Linear", 0.3, true)
            else
                styleLbl.Text = "Style: Combat"
                styleBarFill:TweenSize(UDim2.new(0, 0, 1, 0), "Out", "Linear", 0.3, true)
            end

            local unlockOrder = {"Black Leg", "Electro", "Fishman Karate", "Dragon Claw", "Superhuman", "God Human", "Sanguine Art"}
            local foundActive = false
            for _, name in ipairs(unlockOrder) do
                local lbl = styleList[name]
                if lbl then
                    local sl = GetStyleLevel(name)
                    local owned = GetBP(name)
                    if owned then
                        if name == currentStyle then
                            lbl.Text = "-> " .. name .. " (" .. sl .. "/400)"
                            lbl.TextColor3 = ac(0, 255, 200)
                            foundActive = true
                        else
                            lbl.Text = "✓ " .. name
                            lbl.TextColor3 = ac(80, 230, 80)
                        end
                    else
                        if not foundActive then
                            lbl.Text = "-> " .. name .. " (locked)"
                            lbl.TextColor3 = ac(230, 180, 60)
                            foundActive = true
                        else
                            lbl.Text = "  " .. name
                            lbl.TextColor3 = ac(70, 70, 70)
                        end
                    end
                end
            end
        end)
        if not ok then RemoteLog:log("UILoop", err) end
    end
end)

-- ============================================
