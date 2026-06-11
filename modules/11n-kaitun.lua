-- ============================================
-- MODULE 11n: Kaitun Mode — True Auto Progression
-- Intelligent 1-to-2550 leveling with style mastery,
-- stat distribution, boss fights, and sea progression.
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
-- Chain: Black Leg -> Electro -> Fishman Karate -> Dragon Claw -> Superhuman -> Godhuman
local function KaitunFightingStyle()
    if not _G.KaitunMode then return end
    pcall(function()
        local remote = replicated.Remotes.CommF_
        local lvl = plr.Data.Level.Value

        -- Get current fighting style level
        local function GetStyleLevel(name)
            local bp = plr.Backpack:FindFirstChild(name)
            local ch = plr.Character:FindFirstChild(name)
            local tool = bp or ch
            if tool and tool:FindFirstChild("Level") then
                return tool.Level.Value
            end
            return 0
        end

        -- Equip best available style
        local styles = {"God Human", "Superhuman", "Dragon Claw", "Fishman Karate", "Electro", "Black Leg", "Death Step", "Sharkman Karate", "Electric Claw", "Combat"}
        for _, s in ipairs(styles) do
            if plr.Backpack:FindFirstChild(s) then
                _G.SelectWeapon = s
                _G.ChooseWP = "Melee"
                break
            end
        end

        -- Buy Black Leg if missing (level 1-50 starter)
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

        -- Dragon Claw: need Fishman Karate level 300 + Blackbeard defeated
        if GetBP("Fishman Karate") and not GetBP("Dragon Claw") and GetStyleLevel("Fishman Karate") >= 300 and lvl >= 850 then
            remote:InvokeServer("BlackbeardReward", "DragonClaw", "2")
            return
        end

        -- Superhuman: need Dragon Claw level 400
        if GetBP("Dragon Claw") and not GetBP("Superhuman") and GetStyleLevel("Dragon Claw") >= 400 and lvl >= 1100 then
            remote:InvokeServer("BuySuperhuman")
            return
        end

        -- Godhuman: need Superhuman level 400 + fragments
        if GetBP("Superhuman") and not GetBP("God Human") and GetStyleLevel("Superhuman") >= 400 and lvl >= 1500 then
            remote:InvokeServer("BuyGodhuman")
            return
        end
    end)
end

-- Auto stat distribution: Melee until 2400, then Defense
local function KaitunAutoStats()
    if not _G.KaitunMode then return end
    pcall(function()
        if plr.Data.Points.Value > 0 then
            local melee = plr.Data.Combat.Value
            if melee < 2400 then
                replicated.Remotes.CommF_:InvokeServer("AddPoint", "Melee", plr.Data.Points.Value)
            else
                replicated.Remotes.CommF_:InvokeServer("AddPoint", "Defense", plr.Data.Points.Value)
            end
        end
    end)
end

-- CheckQuest for Kaitun mode — maps level ranges to proper quests and positions
KaitunCheckQuest = function()
    local lvl = plr.Data.Level.Value
    local questData = {Mob = "", NameQuest = "", ID = 1, Pos = nil, QuestPos = nil}

    if World1 then
        if lvl >= 1 and lvl < 10 then
            questData = {Mob = "Bandit", NameQuest = "JungleQuest", ID = 1,
                Pos = CFrame.new(-968.786, 26.818, -1157.556),
                QuestPos = CFrame.new(-1591.284, 35.912, 152.983)}
        elseif lvl >= 10 and lvl < 30 then
            questData = {Mob = "Monkey", NameQuest = "JungleQuest", ID = 2,
                Pos = CFrame.new(-1497.409, 24.839, 45.519),
                QuestPos = CFrame.new(-1591.284, 35.912, 152.983)}
        elseif lvl >= 30 and lvl < 60 then
            questData = {Mob = "Gorilla", NameQuest = "JungleQuest", ID = 3,
                Pos = CFrame.new(-1138.216, 6.816, -459.586),
                QuestPos = CFrame.new(-1591.284, 35.912, 152.983)}
        elseif lvl >= 60 and lvl < 100 then
            questData = {Mob = "Pirate", NameQuest = "BuggyQuest1", ID = 1,
                Pos = CFrame.new(-1140.176, 4.752, 3827.406),
                QuestPos = CFrame.new(-1140.176, 4.752, 3827.406)}
        elseif lvl >= 100 and lvl < 150 then
            questData = {Mob = "Brute", NameQuest = "BuggyQuest1", ID = 2,
                Pos = CFrame.new(-1140.176, 4.752, 3827.406),
                QuestPos = CFrame.new(-1140.176, 4.752, 3827.406)}
        elseif lvl >= 150 and lvl < 200 then
            questData = {Mob = "Desert Bandit", NameQuest = "DesertQuest", ID = 1,
                Pos = CFrame.new(914.893, 20.494, 4410.767),
                QuestPos = CFrame.new(914.893, 20.494, 4410.767)}
        elseif lvl >= 200 and lvl < 250 then
            questData = {Mob = "Desert Officer", NameQuest = "DesertQuest", ID = 2,
                Pos = CFrame.new(1593.758, 41.371, 3843.897),
                QuestPos = CFrame.new(914.893, 20.494, 4410.767)}
        elseif lvl >= 250 and lvl < 300 then
            questData = {Mob = "Snow Bandit", NameQuest = "SnowQuest", ID = 1,
                Pos = CFrame.new(1386.807, 87.273, -1298.358),
                QuestPos = CFrame.new(1386.807, 87.273, -1298.358)}
        elseif lvl >= 300 and lvl < 375 then
            questData = {Mob = "Snowman", NameQuest = "SnowQuest", ID = 2,
                Pos = CFrame.new(1358.375, 10.312, -1418.311),
                QuestPos = CFrame.new(1386.807, 87.273, -1298.358)}
        elseif lvl >= 375 and lvl < 450 then
            questData = {Mob = "Chief Petty Officer", NameQuest = "MarineQuest2", ID = 1,
                Pos = CFrame.new(-4915.978, 87.777, 4320.641),
                QuestPos = CFrame.new(-5036.247, 28.678, 4324.566)}
        elseif lvl >= 450 and lvl < 525 then
            questData = {Mob = "Sky Bandit", NameQuest = "SkyQuest", ID = 1,
                Pos = CFrame.new(-4727.372, 843.490, -1940.318),
                QuestPos = CFrame.new(-4855.796, 719.031, -2625.364)}
        elseif lvl >= 525 and lvl < 600 then
            questData = {Mob = "Dark Master", NameQuest = "SkyQuest", ID = 2,
                Pos = CFrame.new(-5268.752, 791.039, -1661.770),
                QuestPos = CFrame.new(-4855.796, 719.031, -2625.364)}
        elseif lvl >= 600 and lvl < 675 then
            questData = {Mob = "Prisoner", NameQuest = "PirateQuest", ID = 1,
                Pos = CFrame.new(5313.662, 2.936, 446.370),
                QuestPos = CFrame.new(4875.174, 5.708, 726.779)}
        elseif lvl >= 675 and lvl < 750 then
            questData = {Mob = "Dangerous Prisoner", NameQuest = "PirateQuest", ID = 2,
                Pos = CFrame.new(5680.450, 2.618, 777.784),
                QuestPos = CFrame.new(4875.174, 5.708, 726.779)}
        elseif lvl >= 750 and lvl < 800 then
            questData = {Mob = "Toga Warrior", NameQuest = "ColosseumQuest", ID = 1,
                Pos = CFrame.new(-1744.829, 6.595, -405.355),
                QuestPos = CFrame.new(-1744.829, 6.595, -405.355)}
        else
            questData = {Mob = "Gladiator", NameQuest = "ColosseumQuest", ID = 2,
                Pos = CFrame.new(-1514.443, 33.645, -260.729),
                QuestPos = CFrame.new(-1744.829, 6.595, -405.355)}
        end
    elseif World2 then
        if lvl >= 700 and lvl < 775 then
            questData = {Mob = "Raider", NameQuest = "Area1Quest", ID = 1,
                Pos = CFrame.new(-427.567, 73.314, 1835.421),
                QuestPos = CFrame.new(-427.567, 73.314, 1835.421)}
        elseif lvl >= 775 and lvl < 850 then
            questData = {Mob = "Mercenary", NameQuest = "Area1Quest", ID = 2,
                Pos = CFrame.new(-994.245, 73.314, 1534.926),
                QuestPos = CFrame.new(-427.567, 73.314, 1835.421)}
        elseif lvl >= 850 and lvl < 925 then
            questData = {Mob = "Swan Pirate", NameQuest = "Area2Quest", ID = 1,
                Pos = CFrame.new(636.799, 73.414, 918.004),
                QuestPos = CFrame.new(636.799, 73.414, 918.004)}
        elseif lvl >= 925 and lvl < 1000 then
            questData = {Mob = "Factory Staff", NameQuest = "Area2Quest", ID = 2,
                Pos = CFrame.new(295.686, 73.314, 56.791),
                QuestPos = CFrame.new(636.799, 73.414, 918.004)}
        elseif lvl >= 1000 and lvl < 1075 then
            questData = {Mob = "Marine Lieutenant", NameQuest = "MarineQuest3", ID = 1,
                Pos = CFrame.new(-2441.986, 73.359, -3217.532),
                QuestPos = CFrame.new(-2441.986, 73.359, -3217.532)}
        elseif lvl >= 1075 and lvl < 1150 then
            questData = {Mob = "Marine Captain", NameQuest = "MarineQuest3", ID = 2,
                Pos = CFrame.new(-1879.584, 73.314, -3331.310),
                QuestPos = CFrame.new(-2441.986, 73.359, -3217.532)}
        elseif lvl >= 1150 and lvl < 1225 then
            questData = {Mob = "Zombie", NameQuest = "ZombieQuest", ID = 1,
                Pos = CFrame.new(-5632.901, 5.639, -858.431),
                QuestPos = CFrame.new(-5632.901, 5.639, -858.431)}
        elseif lvl >= 1225 and lvl < 1300 then
            questData = {Mob = "Vampire", NameQuest = "ZombieQuest", ID = 2,
                Pos = CFrame.new(-5975.068, 6.220, -929.116),
                QuestPos = CFrame.new(-5632.901, 5.639, -858.431)}
        elseif lvl >= 1300 and lvl < 1400 then
            questData = {Mob = "Snow Trooper", NameQuest = "SnowMountainQuest", ID = 1,
                Pos = CFrame.new(560.591, 401.001, -5307.711),
                QuestPos = CFrame.new(560.591, 401.001, -5307.711)}
        else
            questData = {Mob = "Winter Warrior", NameQuest = "SnowMountainQuest", ID = 2,
                Pos = CFrame.new(1189.991, 454.186, -5504.828),
                QuestPos = CFrame.new(560.591, 401.001, -5307.711)}
        end
    elseif World3 then
        if lvl >= 1500 and lvl < 1600 then
            questData = {Mob = "Pirate Millionaire", NameQuest = "PiratePortQuest", ID = 1,
                Pos = CFrame.new(-289.767, 43.819, 5579.938),
                QuestPos = CFrame.new(-289.767, 43.819, 5579.938)}
        elseif lvl >= 1600 and lvl < 1700 then
            questData = {Mob = "Dragon Crew Warrior", NameQuest = "DragonWarriorQuest", ID = 1,
                Pos = CFrame.new(7021.504, 55.763, -730.129),
                QuestPos = CFrame.new(6683.492, 16.087, -311.732)}
        elseif lvl >= 1700 and lvl < 1800 then
            questData = {Mob = "Dragon Crew Archer", NameQuest = "DragonWarriorQuest", ID = 2,
                Pos = CFrame.new(6625.123, 378.749, 244.359),
                QuestPos = CFrame.new(6683.492, 16.087, -311.732)}
        elseif lvl >= 1800 and lvl < 1900 then
            questData = {Mob = "Female Islander", NameQuest = "FountainQuest", ID = 1,
                Pos = CFrame.new(4692.794, 797.977, 858.848),
                QuestPos = CFrame.new(5258.279, 38.527, 4050.045)}
        elseif lvl >= 1900 and lvl < 2000 then
            questData = {Mob = "Marine Commodore", NameQuest = "MarineTreeIsland", ID = 1,
                Pos = CFrame.new(2401.312, 123.010, -7589.145),
                QuestPos = CFrame.new(2179.301, 28.731, -6739.974)}
        elseif lvl >= 2000 and lvl < 2100 then
            questData = {Mob = "Fishman Raider", NameQuest = "DeepForestIsland", ID = 1,
                Pos = CFrame.new(-10941.035, 332.283, -8760.176),
                QuestPos = CFrame.new(-13232.683, 332.404, -7626.012)}
        elseif lvl >= 2100 and lvl < 2200 then
            questData = {Mob = "Forest Pirate", NameQuest = "DeepForestIsland2", ID = 1,
                Pos = CFrame.new(-13446.554, 413.432, -7760.810),
                QuestPos = CFrame.new(-12682.097, 390.887, -9902.124)}
        elseif lvl >= 2200 and lvl < 2300 then
            questData = {Mob = "Reborn Skeleton", NameQuest = "HauntedQuest1", ID = 1,
                Pos = CFrame.new(-8764.666, 142.192, 5963.483),
                QuestPos = CFrame.new(-9516.993, 172.018, 6078.465)}
        elseif lvl >= 2300 and lvl < 2400 then
            questData = {Mob = "Living Zombie", NameQuest = "HauntedQuest2", ID = 1,
                Pos = CFrame.new(-10227.473, 421.645, 6161.233),
                QuestPos = CFrame.new(-9516.993, 172.018, 6078.465)}
        else
            questData = {Mob = "Demonic Soul", NameQuest = "HauntedQuest2", ID = 2,
                Pos = CFrame.new(-9579.311, 6.129, 6194.186),
                QuestPos = CFrame.new(-9516.993, 172.018, 6078.465)}
        end
    end
    return questData
end

-- Sea progression: teleport to next sea when level threshold is met
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
        end

        -- Sea 2 -> Sea 3 (level 1500+)
        if World2 and lvl >= 1500 then
            _tp(CFrame.new(-5089.962, 312.883, -3124.601))
            wait(1)
            replicated.Remotes.CommF_:InvokeServer("TravelMain")
        end
    end)
end

-- Main Kaitun control loop
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

            -- Step 4: Quest-based farming
            local lvl = plr.Data.Level.Value
            local questData = KaitunCheckQuest()
            if not questData or not questData.Mob then task.wait(1); return end

            local questUI = plr.PlayerGui.Main.Quest
            local QuestTitle = questUI.Visible and questUI.Container.QuestTitle.Title.Text or ""
            local enemyName = questData.Mob

            -- Abandon wrong quest
            if questUI.Visible and not string.find(QuestTitle, enemyName) then
                replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                task.wait(0.3)
                return
            end

            -- Accept quest
            if not questUI.Visible then
                local qPos = questData.QuestPos or questData.Pos
                if qPos and (hrp.Position - qPos.Position).Magnitude > 20 then
                    _tp(qPos)
                    task.wait(0.5)
                end
                pcall(function()
                    replicated.Remotes.CommF_:InvokeServer("StartQuest", questData.NameQuest, questData.ID)
                end)
                task.wait(0.5)
                return
            end

            -- Find and kill mobs
            local found = false
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v.Name == enemyName and Attack and Attack.Alive and Attack.Alive(v) then
                    found = true
                    repeat
                        task.wait(Sec)
                        if hrp and v and v:FindFirstChild("HumanoidRootPart") then
                            _tp(v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0))
                            Attack.Kill(v, _G.KaitunMode)
                        end
                    until not _G.KaitunMode or not v.Parent or not v:FindFirstChild("Humanoid") or v.Humanoid.Health <= 0 or not questUI.Visible
                    break
                end
            end

            -- If no live mob found, teleport to spawn area
            if not found then
                local spawnPos = questData.Pos
                if spawnPos then
                    _tp(spawnPos)
                end
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
