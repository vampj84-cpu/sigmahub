-- MODULE 11: Remaining UI Tabs & Feature Loops
-- (Auto Farm Nearest, Factory Raid, Pirate Raid,
--  Ectoplasm, Chests, Berries, Mob Farm, All Island Farm,
--  Settings, Fishing, Quests, Sea Events, Race,
--  Prehistoric, Stats, Raids, Combat, Travel, Shop, Misc)
-- ============================================

Window:Notify({
    Title = "Sigma Hub",
    Content = "Sigma Hub has loaded successfully!",
    Image = "rbxassetid://127632820302449",
    Duration = 5
})

ClosetMons = Tabs.Main:AddToggle({
Name = "Auto Farm Nearest", 
Description = "", 
Default = false, 
Callback = function(Value)
  _G.AutoFarmNear = Value
end})
spawn(function()
  while wait() do
    pcall(function()
      if _G.AutoFarmNear then
        for i,v in pairs(workspace.Enemies:GetChildren()) do
          if v:FindFirstChild("Humanoid") or v:FindFirstChild("HumanoidRootPart") then
            if v.Humanoid.Health > 0 then
              repeat wait() Attack.Kill(v,_G.AutoFarmNear) until not _G.AutoFarmNear or not v.Parent or v.Humanoid.Health <= 0
            end
          end
        end
      end
    end)
  end
end)
FactoryRaids = Tabs.Main:AddToggle({
Name = "Auto Factory Raid", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoFactory = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoFactory then
        local v = GetConnectionEnemies("Core")
        if v then
          repeat wait()
            EquipWeapon(_G.SelectWeapon)
            _tp(CFrame.new(448.46756, 199.356781, -441.389252))
          until v.Humanoid.Health <= 0 or _G.AutoFactory == false
        else
          _tp(CFrame.new(448.46756, 199.356781, -441.389252))
        end
      end
    end)
  end
end)

CastleRaids = Tabs.Main:AddToggle({
Name = "Auto Pirate Raid", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoRaidCastle = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.AutoRaidCastle then
      pcall(function()
      local CFrameCastleRaid = CFrame.new(-5496.17432, 313.768921, -2841.53027, 0.924894512, 7.37058015e-09, 0.380223751, 3.5881019e-08, 1, -1.06665446e-07, -0.380223751, 1.12297109e-07, 0.924894512)
        if (CFrame.new(-5539.3115234375, 313.800537109375, -2972.372314453125).Position - Root.Position).Magnitude <= 500 then
          for i,v in pairs(workspace.Enemies:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
              if v.Name then
                if (v.HumanoidRootPart.Position - Root.Position).Magnitude <= 2000 then
                  repeat wait() Attack.Kill(v,_G.AutoRaidCastle) until not _G.AutoRaidCastle or not v.Parent or v.Humanoid.Health <= 0 or not workspace.Enemies:FindFirstChild(v.Name)
                end
              end
            end
          end
        else
          local Castle_Mob = {"Galley Pirate","Galley Captain","Raider","Mercenary","Vampire","Zombie","Snow Trooper","Winter Warrior","Lab Subordinate","Horned Warrior","Magma Ninja","Lava Pirate","Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior","Snow Lurker","Sea Soldier","Water Fighter"}
          for i = 1,#Castle_Mob do
            if replicated:FindFirstChild(Castle_Mob[i]) then
              for _,v in pairs(replicated:GetChildren()) do
                if table.find(Castle_Mob, v.Name) then _tp(CFrameCastleRaid) end
              end
            end
          end
        end
      end)
    end
  end
end)




Ecto = Tabs.Main:AddToggle({
Name = "Auto Farm Ectoplasm", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoEctoplasm = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoEctoplasm then
        local EctoTable = {"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer","Arctic Warrior"}    
        local v = GetConnectionEnemies(EctoTable)
		if Attack.Alive(v) then
		  repeat wait() Attack.Kill(v, _G.AutoEctoplasm)until not _G.AutoEctoplasm or not v.Parent or v.Humanoid.Health <= 0		        
	    else
	      replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
	    end
      end
    end)
  end
end)

Tabs.Main:AddSection("Chest")

ChestTW = Tabs.Main:AddToggle({
Name = "Auto Farm Chest", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoFarmChest = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.AutoFarmChest then
      pcall(function()
        local CollectionService = game:GetService("CollectionService")
        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer
        local Character = Player.Character or Player.CharacterAdded:Wait()                
        if not Character then return end                
        local Position = Character:GetPivot().Position
        local Chests = CollectionService:GetTagged("_ChestTagged")      
        local Distance, Nearest = math.huge, nil  
        for i = 1, #Chests do
          local Chest = Chests[i]
          local Magnitude = (Chest:GetPivot().Position - Position).Magnitude        
          if not SelectedIsland or Chest:IsDescendantOf(SelectedIsland) then
            if not Chest:GetAttribute("IsDisabled") and Magnitude < Distance then
              Distance = Magnitude
              Nearest = Chest
            end
          end
        end
      if Nearest then _tp(Nearest:GetPivot()) end
      end)
    end
  end
end)

ChestBP = Tabs.Main:AddToggle({
    Name = "Auto Chest Bypass", 
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoChestBP = Value

        if Value then
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local IsFarming = false
            local UncheckedChests = {}
            local FirstRun = true

            local function getCharacter()
                if not LocalPlayer.Character then
                    LocalPlayer.CharacterAdded:Wait()
                end
                LocalPlayer.Character:WaitForChild("HumanoidRootPart")
                return LocalPlayer.Character
            end

            local function getChestsSorted()
                if FirstRun then
                    FirstRun = false
                    for _, Object in pairs(game:GetDescendants()) do
                        if Object.Name:find("Chest") and Object.ClassName == "Part" then
                            table.insert(UncheckedChests, Object)
                        end
                    end
                end

                local Chests = {}
                for _, Chest in pairs(UncheckedChests) do
                    if Chest:FindFirstChild("TouchInterest") then
                        table.insert(Chests, Chest)
                    end
                end

                local RootPart = getCharacter().LowerTorso
                table.sort(Chests, function(a, b)
                    return (RootPart.Position - a.Position).Magnitude < (RootPart.Position - b.Position).Magnitude
                end)
                return Chests
            end

            local function runChestLoop()
                if IsFarming then return end
                IsFarming = true

                task.spawn(function()
                    while _G.AutoChestBP and LocalPlayer.Character and LocalPlayer.Character.Parent do
                        local Chests = getChestsSorted()
                        if #Chests > 0 then
                            local RootPart = getCharacter().HumanoidRootPart
                            RootPart.CFrame = Chests[1].CFrame
                        end
                        task.wait(0.1)
                    end
                    IsFarming = false
                end)
            end

            LocalPlayer.CharacterAdded:Connect(function()
                getCharacter()
                task.wait(0.5)
                if _G.AutoChestBP then
                    runChestLoop()
                end
            end)

            runChestLoop()
        end
    end
})

StopI = Tabs.Main:AddToggle({
Name = "Stop Items", 
Description = "", 
Default = true,
Callback = function(Value)
    _G.StopWhenChalice = Value
end})

spawn(function()
    while wait(0.2) do
        if _G.StopWhenChalice and (_G.AutoFarmChest or _G.AutoChestBP) then
            pcall(function()
                if GetBP("God's Chalice") or GetBP("Sweet Chalice") or GetBP("Fist of Darkness") then
                    _G.AutoFarmChest = false
                    _G.AutoChestBP = false
                end
            end)
        end
    end
end)

Tabs.Main:AddSection("Collect Berry")

Berry = Tabs.Main:AddToggle({
Name = "Auto Farm Berry", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoBerry = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.AutoBerry then
      local CollectionService= game:GetService("CollectionService")
      local Players= game:GetService("Players")
      local Player = Players.LocalPlayer
      local BerryBush = CollectionService:GetTagged("BerryBush")      
      local Distance, Nearest = math.huge      
      for i = 1, #BerryBush do
        local Bush = BerryBush[i]        
        for AttributeName, BerryName in pairs(Bush:GetAttributes()) do
          if not BerryArray or table.find(BerryArray, BerryName) then           
            _tp(Bush.Parent:GetPivot())
            for i = 1, #BerryBush do
            local Bush = BerryBush[i]        
              for AttributeName, BerryName in pairs(Bush:GetChildren()) do
                if not BerryArray or table.find(BerryArray, BerryName) then
                  _tp(BerryName.WorldPivot)
                  fireproximityprompt(BerryName.ProximityPrompt,math.huge)
                end
              end
            end      
          end
        end
      end      
    end
  end
end)



BerryH = Tabs.Main:AddToggle({
Name = "Auto Farm Berry + Hop", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoBerryH = Value
end})

spawn(function()
    while wait(Sec) do
        if _G.AutoBerryH then
            local CollectionService = game:GetService("CollectionService")
            local Players = game:GetService("Players")
            local Player = Players.LocalPlayer
            local BerryBush = CollectionService:GetTagged("BerryBush")

            if #BerryBush == 0 then
                local TeleportService = game:GetService("TeleportService")
                local ServerList = {}
                
                local Success, Error = pcall(function()
                    ServerList = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                end)
                
                if Success and ServerList.data then
                    for _, Server in pairs(ServerList.data) do
                        if Server.playing < Server.maxPlayers and Server.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, Server.id, Player)
                            break
                        end
                    end
                end
            else
                for i = 1, #BerryBush do
                    local Bush = BerryBush[i]
                    
                    for AttributeName, BerryName in pairs(Bush:GetAttributes()) do
                        if not BerryArray or table.find(BerryArray, BerryName) then
                            _tp(Bush.Parent:GetPivot())
                            
                            for j = 1, #BerryBush do
                                local Bush2 = BerryBush[j]
                                
                                for _, BerryChild in pairs(Bush2:GetChildren()) do
                                    if not BerryArray or table.find(BerryArray, BerryChild.Name) then
                                        _tp(BerryChild.WorldPivot)
                                        fireproximityprompt(BerryChild.ProximityPrompt, math.huge)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

Tabs.Main:AddSection("Farm Mob")
if World1 then
    Tabs.Main:AddDropdown({
        Name = "Select Mob",
        Default = Bandit,
        Options = {
            "Bandit", "Monkey", "Gorilla", "Pirate", "Brute",
            "Desert Bandit", "Desert Officer", "Snow Bandit", "Snowman",
            "Chief Petty Officer", "Sky Bandit", "Dark Master", "Toga Warrior",
            "Gladiator", "Military Soldier", "Military Spy",
            "Fishman Warrior", "Fishman Commando",
            "God's Guard", "Shanda", "Royal Squad", "Royal Soldier",
            "Galley Pirate", "Galley Captain",
        },
        Callback = function(Value)
            getgenv().SelectMob = Value
        end
    })
end
if World2 then
    Tabs.Main:AddDropdown({
        Name = "Select Mob",
        Default = Raider,
        Options = {
            "Raider", "Mercenary", "Swan Pirate", "Factory Staff",
            "Marine Lieutenant", "Marine Captain", "Zombie", "Vampire",
            "Snow Trooper", "Winter Warrior", "Lab Subordinate",
            "Horned Warrior", "Magma Ninja", "Lava Pirate",
            "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer",
            "Arctic Warrior", "Snow Lurker", "Sea Soldier", "Water Fighter",
        },
        Callback = function(Value)
            getgenv().SelectMob = Value
        end
    })
end
if World3 then
    Tabs.Main:AddDropdown({
        Name = "Select Mob",
        Options = {
            "Pirate Millionaire", "Dragon Crew Warrior", "Dragon Crew Archer",
            "Female Islander", "Giant Islander", "Marine Commodore",
            "Marine Rear Admiral", "Fishman Raider", "Fishman Captain",
            "Forest Pirate", "Mythological Pirate", "Jungle Pirate",
            "Musketeer Pirate", "Reborn Skeleton", "Living Zombie",
            "Demonic Soul", "Posessed Mummy", "Peanut Scout",
            "Peanut President", "Ice Cream Chef", "Ice Cream Commander",
            "Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker",
            "Cocoa Warrior", "Chocolate Bar Battler", "Sweet Thief",
            "Candy Rebel", "Candy Pirate", "Snow Demon", "Isle Outlaw",
            "Island Boy", "Sun-kissed Warrior", "Isle Champion",
        },
        Callback = function(Value)
            getgenv().SelectMob = Value
        end
    })
end
Tabs.Main:AddToggle({
    Name = "Auto Kill Mob",
    Default = false,
    Callback = function(Value)
        _G.AutoKillMob = Value
    end
})
spawn(function()
    while wait() do
        if _G.AutoKillMob then
            pcall(function()
                if game:GetService("Workspace").Enemies:FindFirstChild(getgenv().SelectMob) then
                    for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == getgenv().SelectMob then
                            if v:FindFirstChild("Humanoid")
                            and v:FindFirstChild("HumanoidRootPart")
                            and v.Humanoid.Health > 0 then                                
                                repeat
                                    game:GetService("RunService").Heartbeat:Wait()
                                    Attack.Kill(v,_G.AutoKillMob)
                                until not _G.AutoKillMob or not v.Parent or v.Humanoid.Health <= 0                                
                            end
                        end
                    end
                end
            end)
        end
    end
end)

Tabs.Main:AddSection("Farm All Island")

local Sea1_Islands = {
    ["Pirates"] = {
        CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929),
        Mobs = {"Bandit"}
    },

    ["Marine"] = {
        CFrame = CFrame.new(-2709.67944, 24.5206585, 2104.24585, -0.744724929, -3.97967455e-08, -0.667371571, 4.32403588e-08, 1, -1.07884304e-07, 0.667371571, -1.09201515e-07, -0.744724929),
        Mobs = {"Trainee"}
    },

    ["Jungle"] = {
        CFrame = CFrame.new(-1600, 36, 150),
        Mobs = {"Monkey", "Gorilla"}
    },

    ["Pirate Village"] = {
        CFrame = CFrame.new(-1100, 4, 3850),
        Mobs = {"Pirate", "Brute"}
    },

    ["Desert"] = {
        CFrame = CFrame.new(1090, 7, 4370),
        Mobs = {"Desert Bandit", "Desert Officer"}
    },

    ["Frozen Village"] = {
        CFrame = CFrame.new(1200, 28, -1500),
        Mobs = {"Snow Bandit", "Snowman"}
    },

    ["Marine Fortress"] = {
        CFrame = CFrame.new(-4500, 20, 4250),
        Mobs = {"Chief Petty Officer"}
    },

    ["Skylands Lower"] = {
        CFrame = CFrame.new(-5000, 700, -2500),
        Mobs = {"Sky Bandit", "Dark Master"}
    },

    ["Prison"] = {
        CFrame = CFrame.new(4875, 6, 735),
        Mobs = {"Prisoner", "Dangerous Prisoner"}
    },

    ["Colosseum"] = {
        CFrame = CFrame.new(-1500, 60, -290),
        Mobs = {"Toga Warrior", "Gladiator"}
    },

    ["Magma Village"] = {
        CFrame = CFrame.new(-5200, 8, 8400),
        Mobs = {"Military Soldier", "Military Spy"}
    },

    ["Underwater City"] = {
        CFrame = CFrame.new(61160, 5, 1819),
        Mobs = {"Fishman Warrior", "Fishman Commando"}
    },

    ["Skylands Upper"] = {
        CFrame = CFrame.new(-7880, 5545, -380),
        Mobs = {"Shanda", "Royal Squad", "Royal Soldier"}
    }
}


local Sea2_Islands = {

    ["Kingdom of Rose"] = {
        CFrame = CFrame.new(-321, 73, 297),
        Mobs = {
            "Raider",
            "Mercenary",
            "Swan Pirate",
            "Factory Staff"
        }
    },

    ["Green Zone"] = {
        CFrame = CFrame.new(-2447, 73, -3211),
        Mobs = {
            "Marine Lieutenant",
            "Marine Captain"
        }
    },

    ["Graveyard Island"] = {
        CFrame = CFrame.new(-9515, 142, 5536),
        Mobs = {
            "Zombie",
            "Vampire"
        }
    },

    ["Snow Mountain"] = {
        CFrame = CFrame.new(561, 401, -5306),
        Mobs = {
            "Snow Trooper",
            "Winter Warrior"
        }
    },

    ["Hot and Cold (Cold)"] = {
        CFrame = CFrame.new(-6026, 15, -5062),
        Mobs = {
            "Lab Subordinate",
            "Horned Warrior"
        }
    },

    ["Hot and Cold (Hot)"] = {
        CFrame = CFrame.new(-5478, 15, -5240),
        Mobs = {
            "Magma Ninja",
            "Lava Pirate"
        }
    },

    ["Cursed Ship"] = {
        CFrame = CFrame.new(902, 126, 33071),
        Mobs = {
            "Ship Deckhand",
            "Ship Engineer",
            "Ship Steward",
            "Ship Officer"
        }
    },

    ["Ice Castle"] = {
        CFrame = CFrame.new(6137, 294, -6747),
        Mobs = {
            "Arctic Warrior",
            "Snow Lurker"
        }
    },

    ["Forgotten Island"] = {
        CFrame = CFrame.new(-3043, 238, -10191),
        Mobs = {
            "Sea Soldier",
            "Water Fighter"
        }
    }
}


local Sea3_Islands = {

    ["Port Town"] = {
        CFrame = CFrame.new(-290, 44, 5450),
        Mobs = {
            "Pirate Millionaire",
            "Pistol Billionaire"
        }
    },

    ["Hydra Island"] = {
        CFrame = CFrame.new(5228, 604, 345),
        Mobs = {
            "Dragon Crew Warrior",
            "Dragon Crew Archer",
            "Female Islander",
            "Giant Islander",
            "Training Dummy"
        }
    },

    ["Great Tree"] = {
        CFrame = CFrame.new(2682, 1682, -7190),
        Mobs = {
            "Marine Commodore",
            "Marine Rear Admiral"
        }
    },

    ["Floating Turtle"] = {
        CFrame = CFrame.new(-12000, 331, -8500),
        Mobs = {
            "Forest Pirate",
            "Mythological Pirate",
            "Jungle Pirate",
            "Musketeer Pirate",
            "Fishman Raider",
            "Fishman Captain"
        }
    },

    ["Haunted Castle"] = {
        CFrame = CFrame.new(-9515, 142, 5536),
        Mobs = {
            "Reborn Skeleton",
            "Living Zombie",
            "Demonic Soul",
            "Posessed Mummy"
        }
    },

    ["Sea of Treats"] = {
        CFrame = CFrame.new(-1145, 13, -14450),
        Mobs = {
            "Peanut Scout",
            "Peanut President",
            "Ice Cream Commander",
            "Cookie Crafter",
            "Cake Guard",
            "Baking Staff",
            "Head Baker",
            "Cocoa Warrior",
            "Chocolate Bar Battler",
            "Sweet Thief",
            "Candy Rebel"
        }
    },

    ["Tiki Outpost"] = {
        CFrame = CFrame.new(-16200, 90, -17300),
        Mobs = {
            "Isle Outlaw",
            "Island Boy",
            "Sun-kissed Warrior",
            "Isle Champion"
        }
    },

    ["Submerged Island"] = {
        CFrame = CFrame.new(-3200, -10, -10000),
        Mobs = {
            "Reef Bandit",
            "Coral Pirate",
            "Sea Chanter",
            "Ocean Prophet",
            "High Disciple",
            "Grand Devotee"
        }
    }
}


if World1 then
    Tabs.Main:AddDropdown({
        Name = "Select Island",
        Options = {"Pirates", "Marine", "Jungle", "Pirate Village", "Desert", "Frozen Village", "Marine Fortress", "Skylands Lower", "Prison", "Colosseum", "Magma Village", "Underwater City", "Skylands Upper"},
        Callback = function(Value)
            _G.SelectIsland = Value
        end
    })
end

if World2 then
    Tabs.Main:AddDropdown({
        Name = "Select Island",
        Options = {"Kingdom of Rose", "Green Zone", "Graveyard Island", "Snow Mountain", "Hot and Cold (Cold)", "Hot and Cold (Hot)", "Cursed Ship", "Ice Castle", "Forgotten Island"},
        Callback = function(Value)
            _G.SelectIsland = Value
        end
    })
end

if World3 then
    Tabs.Main:AddDropdown({
        Name = "Select Island",
        Options = {"Port Town", "Hydra Island", "Great Tree", "Floating Turtle", "Haunted Castle", "Sea of Treats", "Tiki Outpost", "Submerged Island"},
        Callback = function(Value)
            _G.SelectIsland = Value
        end
    })
end
local IslandData
if World1 then
    IslandData = Sea1_Islands
elseif World2 then
    IslandData = Sea2_Islands
elseif World3 then
    IslandData = Sea3_Islands
end
Tabs.Main:AddToggle({
    Name = "Auto Farm All Island",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmIsland = Value
    end
})


task.spawn(function()
    while task.wait(0.2) do
        if not _G.AutoFarmIsland then continue end
        if not _G.SelectIsland then continue end
        if not IslandData then continue end

        local island = IslandData[_G.SelectIsland]
        if not island then continue end

        local islandPos = island.CFrame
        local mobs = island.Mobs

        local MobMap = {}
        for _, name in ipairs(mobs) do
            MobMap[name] = true
        end

        local found = false

        for _, v in pairs(workspace.Enemies:GetChildren()) do
            if MobMap[v.Name]
            and v:FindFirstChild("Humanoid")
            and v:FindFirstChild("HumanoidRootPart")
            and v.Humanoid.Health > 0 then

                found = true
                repeat
                    task.wait()
                    _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,10,0))
                    Attack.Kill(v, true)
                until not _G.AutoFarmIsland
                   or not v.Parent
                   or v.Humanoid.Health <= 0
            end
        end

        if not found then
            _tp(islandPos)
        end
    end
end)

Tabs.Main:AddSection("Farm Elite Hunter")

local Process = Tabs.Main:AddParagraph("Elites Process", "")
spawn(function()
    while wait(Sec) do
        pcall(function()    
            Process:SetDesc("Elite Progress : " .. replicated.Remotes.CommF_:InvokeServer("EliteHunter", "Progress"))
        end)
    end
end)

local EliteHunter = Tabs.Main:AddParagraph("Elite Spawn", "Status: ")
spawn(function()
    local previousStatus = ""
    while wait(1) do
        local currentStatus = (game:GetService("ReplicatedStorage"):FindFirstChild("Diablo") or 
                               game:GetService("ReplicatedStorage"):FindFirstChild("Deandre") or 
                               game:GetService("ReplicatedStorage"):FindFirstChild("Urban") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Diablo") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Deandre") or 
                               game:GetService("Workspace").Enemies:FindFirstChild("Urban")) and '✅' or '❌'
        local progress = game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
        if currentStatus ~= previousStatus then
            EliteHunter:SetDesc("Status: " .. currentStatus .. " | Killed: " .. progress)
            previousStatus = currentStatus
        end
    end
end)

EliteQ = Tabs.Main:AddToggle({
    Name = "Auto Farm Elite",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.FarmEliteHunt = Value
end})

spawn(function()
    while wait(1) do
        pcall(function()
            if _G.FarmEliteHunt then
                local questGui = plr.PlayerGui.Main.Quest
                local questTitle = questGui.Container.QuestTitle.Title.Text

                if not questGui.Visible then
                    
                    local result = replicated.Remotes.CommF_:InvokeServer("EliteHunter")
                    if result == nil or string.find(result, "Cooldown") then
                      
                        wait(10)
                        return
                    end
                    task.wait(1)
                else
                    
                    local eliteName = nil
                    for _, name in pairs({"Diablo", "Urban", "Deandre"}) do
                        if string.find(questTitle, name) then
                            eliteName = name
                            break
                        end
                    end

                    if eliteName then
                        local boss = nil
                        
                        for _, v in pairs(replicated:GetChildren()) do
                            if v.Name == eliteName and v:FindFirstChild("HumanoidRootPart") then
                                boss = v
                                break
                            end
                        end
                        for _, v in pairs(Enemies:GetChildren()) do
                            if v.Name == eliteName and Attack.Alive(v) then
                                boss = v
                                break
                            end
                        end

                        if boss and boss:FindFirstChild("HumanoidRootPart") then
                            _tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                            repeat
                                wait()
                                Attack.Kill(boss, _G.FarmEliteHunt)
                            until not _G.FarmEliteHunt or not boss.Parent or boss.Humanoid.Health <= 0 or not questGui.Visible
                        else
                           
                            wait(5)
                        end
                    else
                       
                        replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                end
            end
        end)
    end
end)

EliteH = Tabs.Main:AddToggle({
	Name = "Auto Farm Elite + Hop",
	Description = "",
	Default = false,
	Callback = function(Value)
	_G.FarmEliteH = Value
end})


local function HopServer()
	local Http = game:GetService("HttpService")
	local TPS = game:GetService("TeleportService")
	local Api = "https://games.roblox.com/v1/games/"
	local PlaceID = game.PlaceId
	local Servers = {}
	local Cursor = ""
	local foundServer = false

	repeat
		local success, result = pcall(function()
			return game:HttpGet(Api .. PlaceID .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. Cursor)
		end)
		if success and result then
			local data = Http:JSONDecode(result)
			if data.data then
				for _, v in pairs(data.data) do
					if v.playing < v.maxPlayers and v.id ~= game.JobId then
						foundServer = true
						TPS:TeleportToPlaceInstance(PlaceID, v.id)
						break
					end
				end
				Cursor = data.nextPageCursor or ""
			end
		end
	until not Cursor or foundServer
end


spawn(function()
	while task.wait(1) do
		pcall(function()
			if _G.FarmEliteH then
				local questGui = plr.PlayerGui.Main.Quest
				local questTitle = questGui.Container.QuestTitle.Title.Text

				
				if not questGui.Visible then
					local result = replicated.Remotes.CommF_:InvokeServer("EliteHunter")
					if result == nil or string.find(result, "Cooldown") then
					
						HopServer()
						return
					end
					task.wait(1)

				else
				
					local eliteName = nil
					for _, name in pairs({"Diablo", "Urban", "Deandre"}) do
						if string.find(questTitle, name) then
							eliteName = name
							break
						end
					end

					if eliteName then
						local boss = nil
						for _, v in pairs(replicated:GetChildren()) do
							if v.Name == eliteName and v:FindFirstChild("HumanoidRootPart") then
								boss = v
								break
							end
						end
						for _, v in pairs(workspace.Enemies:GetChildren()) do
							if v.Name == eliteName and Attack.Alive(v) then
								boss = v
								break
							end
						end

						if boss and boss:FindFirstChild("HumanoidRootPart") then
							_tp(boss.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
							repeat
								wait()
								Attack.Kill(boss, _G.FarmEliteH)
							until not _G.FarmEliteH or not boss.Parent or boss.Humanoid.Health <= 0 or not questGui.Visible
						else
						
							task.wait(5)
							HopServer()
						end
					else
					
						replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
						task.wait(1)
						HopServer()
					end
				end
			end
		end)
	end
end)

Tabs.Main:AddSection("Farm Rip Indra")

Tabs.Main:AddToggle({
Name = "Auto Attack Rip Indra", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoRipIngay = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoRipIngay then
        local v = GetConnectionEnemies("rip_indra")
	    if not GetWP("Dark Dagger") or not GetIn("Valkyrie") and v then
	      repeat wait() Attack.Kill(v,_G.AutoRipIngay)until not _G.AutoRipIngay or not v.Parent or v.Humanoid.Health <= 0
        else
          replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5097.93164, 316.447021, -3142.66602, -0.405007899, -4.31682743e-08, 0.914313197, -1.90943332e-08, 1, 3.8755779e-08, -0.914313197, -1.76180437e-09, -0.405007899))
		  wait(.1)_tp(CFrame.new(-5344.822265625, 423.98541259766, -2725.0930175781))
	    end
      end
    end)
  end
end)

Tabs.Main:AddToggle({
Name = "Auto Unlocked Haki", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoUnHaki = Value
end})
AuraSkin = function(HakiID)
  local args = {[1] = {["StorageName"] = HakiID,["Type"] = "AuraSkin",["Context"] = "Equip"}};
  replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/FruitCustomizerRF"):InvokeServer(unpack(args));
end;
VaildColor = function(Part)
  if Part and Part.BrickColor then return (tostring(Part.BrickColor) == "Lime green") end;
end;
HakiCalculate = function(Part)
  local ID = {["Really red"] = "Pure Red";["Oyster"] = "Snow White";["Hot pink"] = "Winter Sky";};
  if Part and Part.BrickColor then return (ID[tostring(Part.BrickColor)])end;
end;
spawn(function()
  while wait(Sec) do
    if _G.AutoUnHaki then
      pcall(function()
        local Summoner = workspace.Map["Boat Castle"]:FindFirstChild("Summoner");
        if Summoner and Summoner:FindFirstChild("Circle") then 
          for i,v in pairs(Summoner:FindFirstChild("Circle"):GetChildren()) do 
            if v.Name == "Part" then 
            local TogglesPart = v:FindFirstChild("Part");
              if VaildColor(TogglesPart) == false then 
                AuraSkin(HakiCalculate(v));
                repeat wait() _tp(v.CFrame) until VaildColor(TogglesPart) == true or not _G.AutoUnHaki;
              end
            end            
          end
        end        
      end)
    end
  end
end)

Tabs.Main:AddSection("Farming Cake")
local MobKilled = Tabs.Main:AddParagraph("Cake Princes", "")
spawn(function()
    while wait(0.2) do
        pcall(function()
            local Killed = string.match(replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner"), "%d+")
            if Killed then
                MobKilled:SetDesc("Killed : " .. (500 - tonumber(Killed) or 0))
            end
        end)
    end
end)

Cake = Tabs.Main:AddToggle({
    Name = "Auto Farm Cake Prince",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.Auto_Cake_Prince = Value
end
})

spawn(function()
    while task.wait() do
        if _G.Auto_Cake_Prince and not _G.AutoRaidCastle then
            pcall(function()
                local player = game.Players.LocalPlayer
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                local questUI = player.PlayerGui.Main.Quest
                local enemies = workspace.Enemies
                local cakeMap = workspace.Map:FindFirstChild("CakeLoaf")
                local bigMirror = cakeMap and cakeMap:FindFirstChild("BigMirror")
                if not root then return end

                if _G.AcceptQuestC and questUI and not questUI.Visible then
                    local questPos = CFrame.new(-1927.92, 37.8, -12842.54)
                    _tp(questPos)
                    while (questPos.Position - root.Position).Magnitude > 50 do
                        task.wait(0.2)
                    end
                    local randomQuest = math.random(1, 4)
                    local questData = {
                        [1] = {"StartQuest", "CakeQuest2", 2},
                        [2] = {"StartQuest", "CakeQuest2", 1},
                        [3] = {"StartQuest", "CakeQuest1", 1},
                        [4] = {"StartQuest", "CakeQuest1", 2}
                    }
                    pcall(function()
                        game.ReplicatedStorage.Remotes.CommF_:InvokeServer(unpack(questData[randomQuest]))
                    end)
                end

                if not cakeMap then
                    _tp(CFrame.new(-2077, 252, -12373))
                    task.wait(2)
                    return
                end

                if bigMirror and (bigMirror.Other.Transparency == 0 or enemies:FindFirstChild("Cake Prince")) then
                    local boss = GetConnectionEnemies("Cake Prince")
                    if boss then
                        repeat task.wait()
                            Attack.Kill2(boss, _G.Auto_Cake_Prince)
                        until not _G.Auto_Cake_Prince or not boss.Parent or boss.Humanoid.Health <= 0
                    else
                        _tp(CFrame.new(-2151.82, 149.32, -12404.91))
                    end
                else

                    local CakeMobs = {"Cookie Crafter","Cake Guard","Baking Staff","Head Baker"}
                    local mob = GetConnectionEnemies(CakeMobs)
                    if mob then
                        repeat task.wait()
                            Attack.Kill(mob, _G.Auto_Cake_Prince)
                        until not _G.Auto_Cake_Prince or not mob.Parent or mob.Humanoid.Health <= 0 or (bigMirror and bigMirror.Other.Transparency == 0)
                    else
                        _tp(CFrame.new(-2077, 252, -12373))
                    end
                end
            end)
        end
    end
end)

CakeQ = Tabs.Main:AddToggle({
Name = "Accept Quests", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AcceptQuestC = Value
end
})


CakeSM = Tabs.Main:AddToggle({
    Name = "Auto Summon Cake Prince",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.AutoSpawnCP = Value
end})

spawn(function()
    while task.wait(2) do
        if _G.AutoSpawnCP then
            pcall(function()
                local CommF = game.ReplicatedStorage.Remotes.CommF_
                local enemies = workspace.Enemies
                local bigMirror = workspace.Map.CakeLoaf:FindFirstChild("BigMirror")
                if not bigMirror then return end
                if enemies:FindFirstChild("Cake Prince") then return end
                if bigMirror.Other.Transparency == 0 then return end

                CommF:InvokeServer("CakePrinceSpawner", true)
            end)
        end
    end
end)


Tabs.Main:AddToggle({
    Name = "Auto Dough King [Fully]",
    Default = false,
    Callback = function(Value)
        _G.AutoDoughKing = Value
    end
})

spawn(function()
    while wait() do
        if _G.AutoDoughKing then
            pcall(function()
                if not workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
                    if GetBP("Red Key") then
                        replicated.Remotes.CommF_:InvokeServer("CakeScientist", "Check")
                        replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Check")
                    end
                elseif workspace.Map.CakeLoaf:FindFirstChild("RedDoor") then
                    if GetBP("Red Key") then
                        repeat
                            task.wait()
                            _tp(CFrame.new(-2681.97998, 64.3921585, -12853.7363,0.149007782, -1.87902192e-08, 0.98883605,3.60619588e-08, 1, 1.35681812e-08,-0.98883605, 3.36376011e-08, 0.149007782))
                        until not getgenv().AutoDoughKing or (plr.Character.HumanoidRootPart.CFrame - CFrame.new(-2681.97998, 64.3921585, -12853.7363,0.149007782, -1.87902192e-08, 0.98883605,3.60619588e-08, 1, 1.35681812e-08,-0.98883605, 3.36376011e-08, 0.149007782)).Magnitude <= 5
                        EquipWeapon("Red Key")
                    end
                elseif GetConnectionEnemies("Dough King") then
                    local v = GetConnectionEnemies("Dough King")
                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.AutoDoughKing)
                        until not _G.AutoDoughKing or not v.Parent or v.Humanoid.Health <= 0
                    else
                        _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375))
                    end
                end
                if GetBP("Sweet Chalice") then
                    replicated.Remotes.CommF_:InvokeServer("CakePrinceSpawner", true)
                    _G.AutoAttackDoughKing = true
                else
                    _G.AutoAttackDoughKing = false
                end
                if GetBP("God's Chalice") and GetM("Conjured Cocoa") >= 10 then
                    replicated.Remotes.CommF_:InvokeServer("SweetChaliceNpc")
                end
                if not plr.Backpack:FindFirstChild("God's Chalice")
                    or plr.Character:FindFirstChild("God's Chalice")
                then
                    _G.FarmEliteHunt = true
                else
                    _G.FarmEliteHunt = false
                end
                if GetM("Conjured Cocoa") <= 10 then
                    local v = GetConnectionEnemies{"Cocoa Warrior", "Chocolate Bar Battler"}
                    if v then
                        repeat
                            task.wait()
                            Attack.Kill(v, _G.AutoDoughKing)
                        until _G.AutoDoughKing == false or not v.Parent or v.Humanoid.Health <= 0
                    else
                        _tp(CFrame.new(402.7189025878906, 81.06050109863281, -12259.54296875))
                    end
                end
            end)
        end
    end
end)
Tabs.Main:AddToggle({
    Name = "Auto Farm Dough King",
    Default = false,
    Callback = function(Value)
        _G.AutoAttackDoughKing = Value
    end
})
spawn(function()
    while wait() do
        if _G.AutoAttackDoughKing then
            pcall(function()
                local v = GetConnectionEnemies("Dough King")
                if v then
                    repeat 
                        task.wait()
                        Attack.Kill(v,_G.AutoAttackDoughKing)
                    until not _G.AutoAttackDoughKing or not v.Parent or v.Humanoid.Health <= 0
                else
                    _tp(CFrame.new(-1943.6765, 251.5095, -12337.8809))
                end
            end)
        end
    end
end)

Tabs.Main:AddToggle({
    Name = "Auto Farm Dough King + Hop",
    Default = false,
    Callback = function(Value)
        _G.AutoHop_Dough = Value
    end
})


local function HopServer()
    pcall(function()
        local Http = game:GetService("HttpService")
        local Servers = {}
        local req = game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")
        local data = Http:JSONDecode(req)

        for i,v in pairs(data.data) do
            if v.playing < v.maxPlayers then
                table.insert(Servers, v.id)
            end
        end
        if #Servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, Servers[math.random(1,#Servers)], game.Players.LocalPlayer)
        end
    end)
end


spawn(function()
    while task.wait() do
        if _G.AutoHop_Dough then
            pcall(function()
                local v = GetConnectionEnemies("Dough King")

                if v then
                 
                    repeat 
                        task.wait()
                        Attack.Kill(v, _G.AutoHop_Dough)
                    until not _G.AutoHop_Dough or not v.Parent or v.Humanoid.Health <= 0

                else
                  
                    _tp(CFrame.new(-1943.6765, 251.5095, -12337.8809))

                    task.wait(2)

                    
                    local checkAgain = GetConnectionEnemies("Dough King")

                    if not checkAgain and _G.AutoHop_Dough then
                        HopServer()
                    end
                end
            end)
        end
    end
end)

Tabs.Main:AddSection("Farming Bone")

local CheckingBone = Tabs.Main:AddParagraph("Bones", "")
spawn(function()
    while wait(0.2) do
        pcall(function()
            CheckingBone:SetDesc("Bones : " .. GetM("Bones"))
        end)
    end
end)

Tabs.Main:AddToggle({
    Name = "Auto Farm Bone",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm_Bone = Value
    end
})

spawn(function()
    local player = game.Players.LocalPlayer
    local BonesTable = {
        "Reborn Skeleton",
        "Living Zombie",
        "Demonic Soul",
        "Possessed Mummy"
    }

    while wait(0.5) do
        if not _G.AutoFarm_Bone then continue end

        pcall(function()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end

           
            local questUI =
                player.PlayerGui:FindFirstChild("Main")
                and player.PlayerGui.Main:FindFirstChild("Quest")

            local bone = GetConnectionEnemies(BonesTable)

            
            if _G.AcceptQuestB and questUI and not questUI.Visible then
                local questPos = CFrame.new(-9516.99316,172.01718,6078.46533)
                _tp(questPos)

                repeat wait(2)
                until not _G.AutoFarm_Bone
                   or (questPos.Position - root.Position).Magnitude <= 50

                if not _G.AutoFarm_Bone then return end

                local questData = {
                    {"StartQuest","HauntedQuest2",2},
                    {"StartQuest","HauntedQuest2",1},
                    {"StartQuest","HauntedQuest1",1},
                    {"StartQuest","HauntedQuest1",2}
                }

                game.ReplicatedStorage.Remotes.CommF_:InvokeServer(
                    unpack(questData[math.random(1,#questData)])
                )
            end

           
            if bone then
                repeat
                    wait()
                    Attack.Kill(bone, true)
                until not _G.AutoFarm_Bone
                   or not bone.Parent
                   or bone.Humanoid.Health <= 0
            else
            
                _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125))
            end
        end)
    end
end)

BoneQ = Tabs.Main:AddToggle({
Name = "Accept Quests", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AcceptQuestB = Value
end
})        



Tabs.Main:AddToggle({
Name = "Auto Soul Reaper", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoHytHallow = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.AutoHytHallow then
      pcall(function()
        local v = GetConnectionEnemies("Soul Reaper")
	    if v then
          repeat task.wait() Attack.Kill(v,_G.AutoHytHallow) until v.Humanoid.Health <= 0 or _G.AutoHytHallow == false
        else
          if not GetBP("Hallow Essence") then
            repeat task.wait(.1)replicated.Remotes.CommF_:InvokeServer("Bones","Buy",1,1)until _G.AutoHytHallow == false or GetBP("Hallow Essence")
          else
            repeat wait(.1) _tp(CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))until _G.AutoHytHallow == false or (plr.Character.HumanoidRootPart.CFrame == CFrame.new(-8932.322265625, 146.83154296875, 6062.55078125))
		    EquipWeapon("Hallow Essence")
          end
        end
      end)
    end
  end
end)
RanBone = Tabs.Main:AddToggle({
Name = "Auto Random Bones", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Random_Bone = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Random_Bone then    
  	    repeat task.wait() replicated.Remotes.CommF_:InvokeServer("Bones","Buy",1,1) until not _G.Auto_Random_Bone
      end
    end)
  end
end)
Lucky = Tabs.Main:AddToggle({
Name = "Auto Try Luck Gravestone", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.TryLucky = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.TryLucky then
    local try_bones_luck = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)
      if (plr.Character.HumanoidRootPart.CFrame ~= try_bones_luck) then
        _tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))
	 elseif (plr.Character.HumanoidRootPart.CFrame == try_bones_luck) then
	   replicated.Remotes.CommF_:InvokeServer("gravestoneEvent",1)
      end
    end
  end
end)
Pray = Tabs.Main:AddToggle({
Name = "Auto Pray Gravestone", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Praying = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.Praying then
    local try_bones_luck = CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813)
      if (plr.Character.HumanoidRootPart.CFrame ~= try_bones_luck) then
	   _tp(CFrame.new(-8761.3154296875, 164.85829162598, 6161.1567382813))
      elseif (plr.Character.HumanoidRootPart.CFrame == try_bones_luck) then
	   replicated.Remotes.CommF_:InvokeServer("gravestoneEvent",2)
      end
    end
  end
end)


Tabs.Main:AddSection("Tyrant of the Skies")

local TyrantStatus = Tabs.Main:AddParagraph("Boss Spawn", "")
spawn(function()
    pcall(function()
        while wait(1) do
            if workspace.Enemies:FindFirstChild("Tyrant of the Skies") then
                TyrantStatus:SetDesc("✅")
            else
                TyrantStatus:SetDesc("❌")
            end
        end
    end)
end)
local EyeStatus = Tabs.Main:AddParagraph("Check Status Eyes", "")

function Check_Eye()
    local e = workspace.Map.TikiOutpost.IslandModel
    local eyes = {
        e.Eye1,
        e.Eye2,
        e.IslandChunks.E.Eye3,
        e.IslandChunks.E.Eye4
    }

    local count = 0
    for _, eye in ipairs(eyes) do
        if eye and eye.Transparency ~= 1 then
            count = count + 1
        end
    end

    local isFull = (count == 4)
    return count, isFull
end

task.spawn(function()
    local alerted = false
    while task.wait(1) do
        local current, full = Check_Eye()
        EyeStatus:SetDesc("Eyes: " .. current .. "/4")

        if full and not alerted then
            alerted = true
        elseif not full then
            alerted = false
        end
    end
end)

FarmTyrant = Tabs.Main:AddToggle({
Name = "Auto Farm Boss TOTS", 
Description = "", 
Default = false,
Callback = function(Value) 
    _G.FarmTyrant = Value 
end})

spawn(function()
    while wait(Sec) do
        if _G.FarmTyrant then
            pcall(function()
                if not plr.Character then return end
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                local bossPos = Vector3.new(-16268.287, 152.616, 1390.773)
                
                if (hrp.Position - bossPos).Magnitude > 5 then
                    _tp(CFrame.new(bossPos))
                    repeat wait() until not _G.FarmTyrant or (plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and (plr.Character.HumanoidRootPart.Position - bossPos).Magnitude <= 5)
                end

                local boss = workspace.Enemies:FindFirstChild("Tyrant of the Skies")
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    repeat
                        if not _G.FarmTyrant then break end
                        if Attack and Attack.Kill then
                            Attack.Kill(boss, _G.FarmTyrant)
                        end
                        wait()
                    until not _G.FarmTyrant or not boss.Parent or boss.Humanoid.Health <= 0
                    return
                end

                local mobList = {"Serpent Hunter","Skull Slayer","Isle Champion","Sun-kissed Warrior"}
                for _, mobName in ipairs(mobList) do
                    if not _G.FarmTyrant then break end
                    for _, mob in pairs(workspace.Enemies:GetChildren()) do
                        if not _G.FarmTyrant then break end
                        if mob and mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            if (hrp.Position - mob.HumanoidRootPart.Position).Magnitude > 5000 then
                                _tp(mob.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
                                local t0 = tick()
                                repeat wait() hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") until not _G.FarmTyrant or not hrp or (hrp.Position - mob.HumanoidRootPart.Position).Magnitude <= 6 or tick() - t0 > 8
                            end
                            repeat
                                if not _G.FarmTyrant then break end
                                if Attack and Attack.Kill then
                                    Attack.Kill(mob, _G.FarmTyrant)
                                end
                                wait()
                            until not _G.FarmTyrant or not mob.Parent or mob.Humanoid.Health <= 0
                        end
                    end
                end
            end)
        end
    end
end)

FarmPhaBinh = Tabs.Main:AddToggle({
Name = "Auto Summon Boss", 
Description = "", 
Default = false,
Callback = function(Value)
    _G.FarmPhaBinh = Value
end})

local function sendSkillKey(skillKey)
    local virtualInputManager = game:GetService("VirtualInputManager")
    virtualInputManager:SendKeyEvent(true, skillKey, false, game)
    wait(0.05)
    virtualInputManager:SendKeyEvent(false, skillKey, false, game)
end

local function equipAndUseSkill(toolType)
    local character = plr.Character
    local backpack = plr.Backpack
    if not (character and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0) then return end

    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.ToolTip == toolType then
            item.Parent = character
            wait(0.12)
            for _, skill in ipairs({"Z", "X", "C", "V", "F"}) do
                if not _G.FarmPhaBinh then break end
                pcall(function() sendSkillKey(skill) end)
                wait(0.12)
            end
            item.Parent = backpack
            break
        end
    end
end

local PhaBinhPoints = {
    CFrame.new(-16332.5263671875, 158.07200622558594, 1440.324951171875),
    CFrame.new(-16288.609375, 158.16700744628906, 1470.3680419921875),
    CFrame.new(-16245.412109375, 158.43699645996094, 1463.365966796875),
    CFrame.new(-16212.46875, 158.16700744628906, 1466.343994140625),
    CFrame.new(-16211.9462890625, 158.07200622558594, 1322.39794921875),
    CFrame.new(-16260.921875, 154.92100524902344, 1323.615966796875),
    CFrame.new(-16297.0595703125, 159.322998046875, 1317.2239990234375),
    CFrame.new(-16335.0966796875, 159.33399963378906, 1324.885986328125),
}

spawn(function()
    while wait(Sec) do
        if _G.FarmPhaBinh then
            pcall(function()
                if not (plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0) then return end

                for _, point in ipairs(PhaBinhPoints) do
                    if not _G.FarmPhaBinh then break end

                    _tp(point)

                    local arrived = false
                    local start = tick()
                    while tick() - start < 12 and not arrived and _G.FarmPhaBinh do
                        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                        if not hrp then break end
                        local dist = (hrp.Position - point.Position).Magnitude
                        if dist <= 3 then
                            arrived = true
                            break
                        end
                        wait(0.1)
                    end

                    if _G.FarmPhaBinh and arrived then
                        equipAndUseSkill("Melee")
                        equipAndUseSkill("Sword")
                        equipAndUseSkill("Gun")
                    end
                end
            end)
        end
    end
end)


Tabs.Main:AddSection("Farm Material")

Test = Tabs.Main:AddDropdown({
Name = "Choose Material",
		Description = "",
		Options = MaterialList,
		Callback = function(Value)
			getgenv().SelectMaterial = Value
		end
		})
Toggle = Tabs.Main:AddToggle({
Name = "Auto Farm Materials", 
Description = "", 
Default = false,
Callback = function(Value)
    getgenv().AutoMaterial = Value
end})
spawn(function()
  local function processEnemy(v, EnemyName)
    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
      if v.Name == EnemyName then repeat wait() Attack.Kill(v,getgenv().AutoMaterial) until not getgenv().AutoMaterial or not v.Parent or v.Humanoid.Health <= 0 end
    end
  end
  local function handleEnemySpawns()
    for _, v in pairs(game:GetService("Workspace")["_WorldOrigin"].EnemySpawns:GetChildren()) do
      for _, EnemyName in ipairs(MMon) do
        if string.find(v.Name, EnemyName) then
          if (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).Magnitude >= 10 then
            _tp(v.CFrame * Pos)
          end
        end
      end
    end
  end
  while wait() do
    if getgenv().AutoMaterial then
      pcall(function()
        if getgenv().SelectMaterial then MaterialMon(getgenv().SelectMaterial) _tp(MPos) end
        for _, EnemyName in ipairs(MMon) do
          for _, v in pairs(workspace.Enemies:GetChildren()) do processEnemy(v, EnemyName) end
        end
        handleEnemySpawns()
      end)
    end
  end
end)


Tabs.Main:AddSection("Farm Boss")

		BossDropdown = Tabs.Main:AddDropdown({
		Name = "Select Boss",
		Description = "",
		Options = BossList,
		Callback = function(value)
			_G.FindBoss = value
		end
		})

FarmBoss = Tabs.Main:AddToggle({
    Name = "Auto Farm Boss",
    Description = "",
    Default = false,
    Callback = function(value)
        _G.FarmBoss = value
        spawn(function()
            while wait(Sec) do
                if _G.FarmBoss then
                    pcall(function()
                        local HasQuest = QuestBeta()[2] ~= nil and QuestBeta()[3] ~= nil
                        local QuestTitle = plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text

                       
                        if _G.AcceptQuestBoss and HasQuest then
                            if not string.find(QuestTitle, QuestBeta()[0]) then
                                replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                            end

                            if plr.PlayerGui.Main.Quest.Visible == false then
                                _tp(QuestBeta()[5])
                                if (Root.Position - QuestBeta()[5].Position).Magnitude <= 5 then
                                    replicated.Remotes.CommF_:InvokeServer("StartQuest", QuestBeta()[3], QuestBeta()[2])
                                end
                            elseif plr.PlayerGui.Main.Quest.Visible == true then
                                if workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
                                    for i, v in pairs(workspace.Enemies:GetChildren()) do
                                        if Attack.Alive(v) and v.Name == QuestBeta()[1] then
                                            if string.find(QuestTitle, QuestBeta()[0]) then
                                                repeat
                                                    wait()
                                                    Attack.Kill(v, _G.FarmBoss)
                                                until not _G.FarmBoss or v.Humanoid.Health <= 0 or not v.Parent or plr.PlayerGui.Main.Quest.Visible == false
                                            else
                                                replicated.Remotes.CommF_:InvokeServer("AbandonQuest")
                                            end
                                        end
                                    end
                                else
                                    _tp(QuestBeta()[4])
                                    if replicated:FindFirstChild(QuestBeta()[1]) then
                                        _tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    end
                                end
                            end
                        else
                           
                            if workspace.Enemies:FindFirstChild(QuestBeta()[1]) then
                                for i, v in pairs(workspace.Enemies:GetChildren()) do
                                    if Attack.Alive(v) and v.Name == QuestBeta()[1] then
                                        repeat
                                            wait()
                                            Attack.Kill(v, _G.FarmBoss)
                                        until not _G.FarmBoss or v.Humanoid.Health <= 0 or not v.Parent
                                    end
                                end
                            else
                                _tp(QuestBeta()[4])
                                if replicated:FindFirstChild(QuestBeta()[1]) then
                                    _tp(replicated:FindFirstChild(QuestBeta()[1]).HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end
})


BossQ = Tabs.Main:AddToggle({
    Name = "Accept Quests",
    Description = "",
    Default = true,
    Callback = function(Value)
        _G.AcceptQuestBoss = Value
    end
})

FarmAllBoss = Tabs.Main:AddToggle({
   Name = "Auto Farm All Boss",
    Default = false,
Callback = function(Value)
    _G.AutoFarmAllBoss = Value
end})

task.spawn(function()
    while task.wait(0.3) do
        if _G.AutoFarmAllBoss then
            pcall(function()
                local player = game.Players.LocalPlayer
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
                local hrp = player.Character.HumanoidRootPart

                local nearestBoss, nearestDist = nil, math.huge

                for _, boss in pairs(workspace.Enemies:GetChildren()) do
                    if boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        if table.find(BossList, boss.Name) then
                            local dist = (hrp.Position - boss.HumanoidRootPart.Position).Magnitude
                            if dist < nearestDist then
                                nearestBoss = boss
                                nearestDist = dist
                            end
                        end
                    end
                end

                if nearestBoss and nearestBoss:FindFirstChild("HumanoidRootPart") then
                    local bossHRP = nearestBoss.HumanoidRootPart
                    local humanoid = nearestBoss.Humanoid

                    repeat
                        task.wait(0.1)
                        if not _G.AutoFarmAllBoss then break end

                        local targetCFrame = bossHRP.CFrame * CFrame.new(0, 5, 0)
                        if (hrp.Position - targetCFrame.Position).Magnitude > 100 then
                            player.Character:PivotTo(targetCFrame)
                        else
                            _tp(targetCFrame)
                        end

                        if Attack and typeof(Attack.Kill) == "function" then
                            Attack.Kill(nearestBoss, true)
                        end
                    until not nearestBoss.Parent or humanoid.Health <= 0 or not _G.AutoFarmAllBoss
                end
            end)
        end
    end
end)

Tabs.Main:AddSection("Farming Mastery")
local posMastery = {"Cake","Bone"}
local Mastery_Config = Tabs.Main:AddDropdown({
Name = "Choose Island",
		Description = "",
		Options = posMastery,
		Default = Bone,
		Callback = function(Value)
  SelectIsland = Value
end})
local MasteryFruits = Tabs.Main:AddToggle({
Name = "Auto Mastery Fruits", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.FarmMastery_Dev = Value
end})
spawn(function()RunSer.RenderStepped:Connect(function() pcall(function()if _G.FarmMastery_Dev or _G.FarmMastery_G or _G.FarmMastery_S then for a,b in pairs(plr.PlayerGui.Notifications:GetChildren())do if b.Name=="NotificationTemplate"then if string.find(b.Text,"Skill locked!")then b:Destroy()end end end end end)end) end)
spawn(function()
  while wait(Sec) do
    if _G.FarmMastery_Dev then
      pcall(function()
        if SelectIsland == "Cake" then         
          local v = GetConnectionEnemies(mastery1)
		  if v then		   
		    HealthM = v.Humanoid.MaxHealth * 70 / 100
		    repeat wait()
		      MousePos = v.HumanoidRootPart.Position
		      Attack.Mas(v,_G.FarmMastery_Dev)
		    until _G.FarmMastery_Dev == false or v.Humanoid.Health <= 0 or not v.Parent         		         		        
		  else
		    _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) 
		  end
		elseif SelectIsland == "Bone" then
          local v = GetConnectionEnemies(mastery2)
		  if v then		
		    HealthM = v.Humanoid.MaxHealth * 70 / 100
		    repeat wait()
		      MousePos = v.HumanoidRootPart.Position
		      Attack.Mas(v,_G.FarmMastery_Dev)
		    until _G.FarmMastery_Dev == false or v.Humanoid.Health <= 0 or not v.Parent		        
		  else
		    _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 		    
		  end
        end
      end)
    end
  end
end)
local MasteryGun = Tabs.Main:AddToggle({
Name = "Auto Mastery Gun", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.FarmMastery_G = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.FarmMastery_G then
      pcall(function()
        if SelectIsland == "Cake" then
          local v = GetConnectionEnemies(mastery1)
		  if v then		      
		    HealthM = v.Humanoid.MaxHealth * 70 / 100
		    repeat wait()
		      MousePos = v.HumanoidRootPart.Position
		      Attack.Masgun(v,_G.FarmMastery_G)
		      local Modules = replicated:FindFirstChild("Modules")
              local Net = Modules:FindFirstChild("Net")
              local RE_ShootGunEvent = Net:FindFirstChild("RE/ShootGunEvent")    
              if plr.Character:FindFirstChildOfClass("Tool").ToolTip ~= "Gun" then return end
              if plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name == 'Skull Guitar' then
                SoulGuitar = true
		        plr.Character:FindFirstChildOfClass("Tool").RemoteEvent:FireServer("TAP", MousePos)
		        if _G.FarmMastery_G then
		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);wait(0.05)
                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);wait(0.05)
                end
		      elseif plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name ~= 'Skull Guitar' then
		        SoulGuitar = false
		        RE_ShootGunEvent:FireServer(MousePos, { v.HumanoidRootPart })
		        if _G.FarmMastery_G then
		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);wait(0.05)
                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);wait(0.05)
                end
		      end		            		
		    until _G.FarmMastery_G == false or v.Humanoid.Health <= 0 or not v.Parent    
		    SoulGuitar = false     		         		        
		  else
		    _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) 		    
	  	  end
		elseif SelectIsland == "Bone" then
          local v = GetConnectionEnemies(mastery2)
		  if v then		      
		    HealthM = v.Humanoid.MaxHealth * 70 / 100
		    repeat wait()
		      MousePos = v.HumanoidRootPart.Position
		      Attack.Masgun(v,_G.FarmMastery_G)
		      local Modules = replicated:FindFirstChild("Modules")
              local Net = Modules:FindFirstChild("Net")
              local RE_ShootGunEvent = Net:FindFirstChild("RE/ShootGunEvent")    
              if plr.Character:FindFirstChildOfClass("Tool").ToolTip ~= "Gun" then return end
              if plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name == 'Skull Guitar' then
                SoulGuitar = true
		        plr.Character:FindFirstChildOfClass("Tool").RemoteEvent:FireServer("TAP", MousePos)
		        if _G.FarmMastery_G then
		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);wait(0.05)
                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);wait(0.05)
                end
		      elseif plr.Character:FindFirstChildOfClass("Tool") and plr.Character:FindFirstChildOfClass("Tool").Name ~= 'Skull Guitar' then
		        SoulGuitar = false
		        RE_ShootGunEvent:FireServer(MousePos, { v.HumanoidRootPart })
		        if _G.FarmMastery_G then
		          vim1:SendMouseButtonEvent(0, 0, 0, true, game, 1);wait(0.05)
                  vim1:SendMouseButtonEvent(0, 0, 0, false, game, 1);wait(0.05)
                end
		      end		            		
		    until _G.FarmMastery_G == false or v.Humanoid.Health <= 0 or not v.Parent    
		    SoulGuitar = false     		         		        
		  else
		    _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 
	  	  end
        end
      end)
    end
  end
end)
local MasterySword = Tabs.Main:AddToggle({
Name = "Auto Mastery All Sword", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.FarmMastery_S = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.FarmMastery_S then
        if SelectIsland == "Cake" then
          for _, v in next, replicated.Remotes.CommF_:InvokeServer("getInventory") do          
            if type(v) == "table" then
              if v.Type == "Sword" then
                SwordName = v.Name
                if tonumber(v.Mastery) >= 1 or tonumber(v.Mastery) <= 599 then
                  local v = GetConnectionEnemies(mastery1)
                  if GetBP(SwordName) then                    
		            if v then
                      repeat wait() Attack.Sword(v,_G.FarmMastery_S) until _G.FarmMastery_S == false or not v.Parent or v.Humanoid.Health <= 0		                  
		            else
		              _tp(CFrame.new(-1943.676513671875, 251.5095672607422, -12337.880859375)) 
		            end                    
                  else
                    replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName)   
                  end   
              elseif tonumber(v.Mastery) >= 600 then
                if GetBP(SwordName) then return nil else replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName) end       
              end
                break
              end
            end         
          end
        elseif SelectIsland == "Bone" then
          for _, v in next, replicated.Remotes.CommF_:InvokeServer("getInventory") do          
            if type(v) == "table" then
              if v.Type == "Sword" then
                SwordName = v.Name
                if tonumber(v.Mastery) >= 1 or tonumber(v.Mastery) <= 599 then
                  local v = GetConnectionEnemies(mastery2)
                  if GetBP(SwordName) then                    
		            if v then
                      repeat wait() Attack.Sword(v,_G.FarmMastery_S) until _G.FarmMastery_S == false or not v.Parent or v.Humanoid.Health <= 0		                  
		            else
		              _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 
		            end                    
                  else
                    replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName)   
                  end   
                elseif tonumber(v.Mastery) >= 600 then
                  if GetBP(SwordName) then return nil else replicated.Remotes.CommF_:InvokeServer("LoadItem",SwordName) end       
                end
                break
              end
            end         
          end
        end
      end
    end)
  end
end)






