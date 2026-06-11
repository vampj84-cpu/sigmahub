-- ============================================
-- MODULE 11n: Kaitun Mode — Dynamic Auto Progression
-- Uses the game's own quest data dynamically so it
-- never needs hardcoded level ranges.
-- ============================================

-- NameCall hook for auto-aim in Kaitun mode
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
        humanoid.AnimationPlayed:Connect(function(track)
            if _G.KaitunMode then
                task.spawn(function() track:Stop() end)
            end
        end)
    end)
end

plr.CharacterAdded:Connect(BlockAnimations)
BlockAnimations()

-- Fighting style mastery progression
local function KaitunFightingStyle()
    if not _G.KaitunMode then return end
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
        local styles = {"God Human", "Sanguine Art", "Superhuman", "Dragon Talon", "Electric Claw", "Sharkman Karate", "Death Step", "Dragon Claw", "Fishman Karate", "Electro", "Black Leg", "Combat"}
        for _, s in ipairs(styles) do
            if plr.Backpack:FindFirstChild(s) then
                _G.SelectWeapon = s
                _G.ChooseWP = "Melee"
                break
            end
        end

        -- Buy Black Leg if missing (starter)
        if not GetBP("Black Leg") and not GetBP("Electro") and not GetBP("Fishman Karate") and not GetBP("Dragon Claw") and not GetBP("Superhuman") then
            if lvl >= 1 then
                remote:InvokeServer("BuyBlackLeg")
            end
            return
        end

        -- Electro: need Black Leg level 300
        if GetBP("Black Leg") and not GetBP("Electro") and GetStyleLevel("Black Leg") >= 300 then
            remote:InvokeServer("BuyElectro")
            return
        end

        -- Fishman Karate: need Electro level 300
        if GetBP("Electro") and not GetBP("Fishman Karate") and GetStyleLevel("Electro") >= 300 then
            remote:InvokeServer("BuyFishmanKarate")
            return
        end

        -- Dragon Claw: need Fishman Karate level 300
        if GetBP("Fishman Karate") and not GetBP("Dragon Claw") and GetStyleLevel("Fishman Karate") >= 300 and lvl >= 850 then
            remote:InvokeServer("BlackbeardReward", "DragonClaw", "2")
            return
        end

        -- Superhuman: need Dragon Claw level 400
        if GetBP("Dragon Claw") and not GetBP("Superhuman") and GetStyleLevel("Dragon Claw") >= 400 and lvl >= 1100 then
            remote:InvokeServer("BuySuperhuman")
            return
        end

        -- Godhuman: need Superhuman level 400
        if GetBP("Superhuman") and not GetBP("God Human") and GetStyleLevel("Superhuman") >= 400 and lvl >= 1500 then
            remote:InvokeServer("BuyGodhuman")
            return
        end

        -- Sanguine Art: need Godhuman level 400
        if GetBP("God Human") and not GetBP("Sanguine Art") and GetStyleLevel("God Human") >= 400 and lvl >= 2000 then
            remote:InvokeServer("BuySanguineArt")
            return
        end
    end)
end

-- Auto stat distribution: Melee until 2800 (stat cap), then Defense
local function KaitunAutoStats()
    if not _G.KaitunMode then return end
    pcall(function()
        if plr.Data.Points.Value > 0 then
            local melee = plr.Data.Combat.Value
            if melee < 2800 then
                replicated.Remotes.CommF_:InvokeServer("AddPoint", "Melee", plr.Data.Points.Value)
            else
                replicated.Remotes.CommF_:InvokeServer("AddPoint", "Defense", plr.Data.Points.Value)
            end
        end
    end)
end

-- Find NPC position for quest giver by name
local function FindQuestNPC(npcName)
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.CFrame
        end
    end
    for _, npc in pairs(replicated.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then
            return npc.HumanoidRootPart.CFrame
        end
    end
    return nil
end

-- Find and teleport to enemy spawn area
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

-- Sea progression: move to next sea or Submerged Island at level thresholds
local function KaitunSeaProgression()
    if not _G.KaitunMode then return end
    pcall(function()
        local lvl = plr.Data.Level.Value
        local char = plr.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        -- Sea 1 -> Sea 2 (level 700+)
        if World1 and lvl >= 700 then
            _tp(CFrame.new(-5089.962, 312.883, -3124.601))
            wait(1)
            replicated.Remotes.CommF_:InvokeServer("TravelMain")
            return
        end

        -- Sea 2 -> Sea 3 (level 1500+)
        if World2 and lvl >= 1500 then
            _tp(CFrame.new(-5089.962, 312.883, -3124.601))
            wait(1)
            replicated.Remotes.CommF_:InvokeServer("TravelMain")
            return
        end

        -- Sea 3 -> Submerged Island (level 2600+)
        if World3 and lvl >= 2600 then
            local function IsInSubmerged()
                if not hrp then return false end
                local islandPos = Vector3.new(11520.8, 0, 9829.5)
                local playerXZ = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
                return (playerXZ - islandPos).Magnitude < 3000
            end
            if not IsInSubmerged() then
                local npcPos = CFrame.new(-16269.7041, 25.2288494, 1373.65955)
                _tp(npcPos)
                wait(1)
                pcall(function()
                    replicated.Modules.Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
                end)
                wait(2)
            end
        end
    end)
end

-- Find a live enemy by name from workspace.Enemies or replicated storage
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

-- Main Kaitun control loop — uses dynamic quest data from the game
task.spawn(function()
    while task.wait(0.3) do
        if not _G.KaitunMode then continue end

        pcall(function()
            local char = plr.Character or plr.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            if not hrp then return end

            -- Step 1: Sea progression check
            KaitunSeaProgression()

            -- Step 2: Fighting style upgrade
            KaitunFightingStyle()

            -- Step 3: Auto stats
            KaitunAutoStats()

            -- Step 4: Dynamic quest-based farming
            local questUI = plr.PlayerGui.Main.Quest
            local QuestTitle = questUI.Visible and questUI.Container.QuestTitle.Title.Text or ""

            -- Get quest data dynamically from the game's Quests module
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
                    -- Try finding the NPC directly
                    local foundPos = FindQuestNPC(questName)
                    if foundPos then
                        _tp(foundPos)
                        task.wait(0.5)
                    end
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
                        Attack.Kill(mob, _G.KaitunMode)
                    end
                until not _G.KaitunMode or not mob.Parent or not mob:FindFirstChild("Humanoid") or mob.Humanoid.Health <= 0 or not questUI.Visible
            else
                -- No mob found, go to enemy spawn area
                GotoEnemySpawn(enemyName)
            end
        end)
    end
end)

-- Auto-collect nearby chests in Kaitun mode
task.spawn(function()
    while task.wait(2) do
        if not _G.KaitunMode then continue end
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

-- ============================================
