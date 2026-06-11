-- ============================================
-- MODULE 11n: Kaitun Standalone
-- Self-contained auto-progression with GUI.
-- Loaded via: build-kaitun.lua (concatenated
-- with modules 01-09 for full dependency).
-- ============================================

-- Initialize MousePos for NameCall hook
MousePos = Vector3.new(0, 0, 0)
spawn(function()
    while task.wait() do
        pcall(function()
            MousePos = game.Players.LocalPlayer:GetMouse().Hit.Position
        end)
    end
end)

-- Destroy Sigma Hub UI if present
pcall(function()
    for _, v in pairs(plr.PlayerGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name ~= "Main" and v.Name ~= "NotificationHolder" then
            v:Destroy()
        end
    end
end)

-- NameCall hook for auto-aim
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
                    args[2] = MousePos
                    return old(unpack(args))
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
        humanoid.AnimationPlayed:Connect(function(track)
            task.spawn(function() track:Stop() end)
        end)
    end)
end
plr.CharacterAdded:Connect(BlockAnimations)
BlockAnimations()

-- Fighting style progression
local function KaitunFightingStyle()
    pcall(function()
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

        -- Equip best available fighting style
        local prio = {"God Human", "Sanguine Art", "Superhuman", "Dragon Talon", "Electric Claw", "Sharkman Karate", "Death Step", "Dragon Claw", "Fishman Karate", "Electro", "Black Leg", "Combat"}
        for _, s in ipairs(prio) do
            if plr.Backpack:FindFirstChild(s) then
                _G.SelectWeapon = s
                _G.ChooseWP = "Melee"
                break
            end
        end

        if not GetBP("Black Leg") and not GetBP("Electro") and not GetBP("Fishman Karate") and not GetBP("Dragon Claw") and not GetBP("Superhuman") then
            if lvl >= 1 then remote:InvokeServer("BuyBlackLeg") end
            return
        end
        if GetBP("Black Leg") and not GetBP("Electro") and GetStyleLevel("Black Leg") >= 300 then
            remote:InvokeServer("BuyElectro"); return
        end
        if GetBP("Electro") and not GetBP("Fishman Karate") and GetStyleLevel("Electro") >= 300 then
            remote:InvokeServer("BuyFishmanKarate"); return
        end
        if GetBP("Fishman Karate") and not GetBP("Dragon Claw") and GetStyleLevel("Fishman Karate") >= 300 and lvl >= 850 then
            remote:InvokeServer("BlackbeardReward", "DragonClaw", "2"); return
        end
        if GetBP("Dragon Claw") and not GetBP("Superhuman") and GetStyleLevel("Dragon Claw") >= 400 and lvl >= 1100 then
            remote:InvokeServer("BuySuperhuman"); return
        end
        if GetBP("Superhuman") and not GetBP("God Human") and GetStyleLevel("Superhuman") >= 400 and lvl >= 1500 then
            remote:InvokeServer("BuyGodhuman"); return
        end
        if GetBP("God Human") and not GetBP("Sanguine Art") and GetStyleLevel("God Human") >= 400 and lvl >= 2000 then
            remote:InvokeServer("BuySanguineArt"); return
        end
    end)
end

-- Auto stats: Melee → 2800 then Defense
local function KaitunAutoStats()
    pcall(function()
        if plr.Data.Points.Value > 0 then
            if plr.Data.Combat.Value < 2800 then
                replicated.Remotes.CommF_:InvokeServer("AddPoint", "Melee", plr.Data.Points.Value)
            else
                replicated.Remotes.CommF_:InvokeServer("AddPoint", "Defense", plr.Data.Points.Value)
            end
        end
    end)
end

-- Sea progression
local function KaitunSeaProgression()
    pcall(function()
        local lvl = plr.Data.Level.Value
        local char = plr.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if World1 and lvl >= 700 then
            _tp(CFrame.new(-5089.962, 312.883, -3124.601))
            wait(1)
            replicated.Remotes.CommF_:InvokeServer("TravelMain")
            return
        end
        if World2 and lvl >= 1500 then
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
                _tp(CFrame.new(-16269.7041, 25.2288494, 1373.65955))
                wait(1)
                pcall(function()
                    replicated.Modules.Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
                end)
                wait(2)
            end
        end
    end)
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

local sg = Instance.new("ScreenGui")
sg.Name = "KaitunHub"
sg.ResetOnSpawn = false
sg.Parent = plr:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 340)
frame.Position = UDim2.new(0, 15, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
frame.BorderColor3 = Color3.fromRGB(0, 200, 200)
frame.Active = true
frame.Draggable = true
frame.Parent = sg

local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 170, 170)
titleBar.Text = "  Kaitun Mode"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.GothamBold
titleBar.TextSize = 15
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Parent = frame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -28, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

local function makeLabel(parent, posY, text, color)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 18)
    lbl.Position = UDim2.new(0, 5, 0, posY)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color or Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

makeLabel(frame, 32, "Level: 1 / 2800", Color3.fromRGB(255, 255, 255))
makeLabel(frame, 50, "Sea: 1 (First Sea)", nil)
makeLabel(frame, 68, "Farming: --", nil)
makeLabel(frame, 86, "Style: --", Color3.fromRGB(0, 255, 200))
makeLabel(frame, 104, "Status: Starting...", Color3.fromRGB(255, 200, 100))

local div = Instance.new("Frame")
div.Size = UDim2.new(1, -10, 0, 1)
div.Position = UDim2.new(0, 5, 0, 120)
div.BackgroundColor3 = Color3.fromRGB(0, 170, 170)
div.BorderSizePixel = 0
div.Parent = frame

local stylesLabel = makeLabel(frame, 125, "Fighting Styles:", Color3.fromRGB(0, 200, 200))

local styleList = {}
local styleNames = {"Black Leg", "Electro", "Fishman Karate", "Dragon Claw", "Superhuman", "God Human", "Sanguine Art"}

for i, name in ipairs(styleNames) do
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 16)
    lbl.Position = UDim2.new(0, 15, 0, 143 + (i - 1) * 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = "  " .. name
    lbl.TextColor3 = Color3.fromRGB(100, 100, 100)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame
    styleList[name] = lbl
end

local statusLbl = makeLabel(frame, 143 + #styleNames * 16 + 4, "made by josiah", Color3.fromRGB(80, 80, 80))
statusLbl.TextXAlignment = Enum.TextXAlignment.Center
statusLbl.Size = UDim2.new(1, 0, 0, 16)
statusLbl.Position = UDim2.new(0, 0, 0, 143 + #styleNames * 16 + 4)

-- Assign aliases for GUI updates
local levelLbl = frame:FindFirstChild("TextLabel")
local seaLbl, farmLbl, styleLbl, statusText

for _, v in pairs(frame:GetChildren()) do
    if v:IsA("TextLabel") then
        if v.Text:find("^Level:") then levelLbl = v
        elseif v.Text:find("^Sea:") then seaLbl = v
        elseif v.Text:find("^Farming:") then farmLbl = v
        elseif v.Text:find("^Style:") then styleLbl = v
        elseif v.Text:find("^Status:") then statusText = v
        end
    end
end

-- ============================================
-- Main farming loop
-- ============================================

task.spawn(function()
    local styleCheckTimer = 0
    while task.wait(0.3) do
        pcall(function()
            local char = plr.Character or plr.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            if not hrp then return end

            -- Sea progression
            KaitunSeaProgression()

            -- Fighting style + stats (every 3s, not every tick)
            styleCheckTimer = styleCheckTimer + 1
            if styleCheckTimer >= 10 then
                styleCheckTimer = 0
                KaitunFightingStyle()
                KaitunAutoStats()
            end

            -- Quest-based farming
            local questUI = plr.PlayerGui.Main.Quest
            local QuestTitle = questUI.Visible and questUI.Container.QuestTitle.Title.Text or ""

            local questData = QuestNeta()
            if not questData or not questData[1] then task.wait(1); return end

            local enemyName = questData[1]
            local questName = questData[3]
            local questId = questData[2]
            local questPos = questData[6]

            -- Abandon wrong quest
            if questUI.Visible and not string.find(QuestTitle, enemyName) then
                replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                task.wait(0.3)
                return
            end

            -- Accept quest
            if not questUI.Visible then
                if questPos then
                    if (hrp.Position - questPos.Position).Magnitude > 20 then
                        _tp(questPos)
                        task.wait(0.5)
                    end
                    if (hrp.Position - questPos.Position).Magnitude <= 30 then
                        replicated.Remotes.CommF_:InvokeServer("StartQuest", questName, questId)
                    end
                else
                    replicated.Remotes.CommF_:InvokeServer("StartQuest", questName, questId)
                end
                task.wait(0.5)
                return
            end

            -- Find and kill mobs
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
    end
end)

-- Auto-collect chests
task.spawn(function()
    while task.wait(2) do
        pcall(function()
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
        pcall(function()
            local lvl = plr.Data.Level.Value
            local sea = (World1 and 1) or (World2 and 2) or (World3 and 3) or 1
            levelLbl.Text = "Level: " .. string.format("%d / 2800", lvl)
            seaLbl.Text = "Sea: " .. (seaNames[sea] or "?")

            -- Farming target
            local questUI = plr.PlayerGui.Main.Quest
            if questUI.Visible then
                local title = questUI.Container.QuestTitle.Title.Text
                farmLbl.Text = "Farming: " .. title
                statusText.Text = "Status: Engaging enemy..."
                statusText.TextColor3 = Color3.fromRGB(100, 255, 100)
            else
                farmLbl.Text = "Farming: Seeking quest..."
                statusText.Text = "Status: Traveling..."
                statusText.TextColor3 = Color3.fromRGB(255, 200, 100)
            end

            -- Fighting style progress
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
            else
                styleLbl.Text = "Style: Combat"
            end

            -- Fighting styles unlocked display
            local unlockOrder = {"Black Leg", "Electro", "Fishman Karate", "Dragon Claw", "Superhuman", "God Human", "Sanguine Art"}
            local foundActive = false
            for _, name in ipairs(unlockOrder) do
                local lbl = styleList[name]
                if lbl then
                    local sl = GetStyleLevel(name)
                    local owned = GetBP(name)
                    if owned then
                        if name == currentStyle then
                            lbl.Text = "→ " .. name .. " (" .. sl .. "/400)"
                            lbl.TextColor3 = Color3.fromRGB(0, 255, 200)
                            foundActive = true
                        else
                            lbl.Text = "✓ " .. name
                            lbl.TextColor3 = Color3.fromRGB(100, 255, 100)
                        end
                    else
                        if not foundActive then
                            lbl.Text = "→ " .. name .. " (locked)"
                            lbl.TextColor3 = Color3.fromRGB(255, 200, 100)
                            foundActive = true
                        else
                            lbl.Text = "  " .. name
                            lbl.TextColor3 = Color3.fromRGB(80, 80, 80)
                        end
                    end
                end
            end
        end)
    end
end)

-- ============================================
