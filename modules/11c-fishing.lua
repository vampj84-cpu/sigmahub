-- ============================================
-- MODULE 11c: Fishing Tab
-- ============================================

Tabs.Fish:AddSection("Fishing")

Tabs.Fish:AddDropdown({
    Name = "Select Fishing Rod",
    Description = "",
    Options = {"Fishing Rod", "Gold Rod", "Shark Rod", "Shell Rod", "Treasure Rod"},
    Default = "Fishing Rod",
    Callback = function(Value)
        _G.SelectedRod = Value
    end
})

BaitDropdown = Tabs.Fish:AddDropdown({
    Name = "Select Bait",
    Description = "",
    Options = {"Basic Bait", "Kelp Bait", "Good Bait", "Abyssal Bait", "Frozen Bait", "Epic Bait", "Carnivore Bait"},
    Default = "Basic Bait",
    Callback = function(Value)
        _G.SelectedBait = Value
        if _G.AutoBuyBait then
            pcall(function()
                Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
            end)
        end
    end
})

BuyBaitToggle = Tabs.Fish:AddToggle({
    Name = "Auto Buy Bait",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoBuyBait = Value
        if Value then
            pcall(function()
                Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
            end)
        end
    end
})


task.spawn(function()
    while task.wait(2) do
        if _G.AutoBuyBait and _G.SelectedBait then
            pcall(function()
                Remotes.RFCraft:InvokeServer("Craft", _G.SelectedBait, {})
            end)
        end
    end
end)




FishingToggle = Tabs.Fish:AddToggle({
    Name = "Auto Fishing",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoFishing = Value
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishReplicated = ReplicatedStorage:WaitForChild("FishReplicated")
local FishingRequest = FishReplicated:WaitForChild("FishingRequest")
local Config = require(FishReplicated.FishingClient.Config)
local GetWaterHeight = require(ReplicatedStorage.Util.GetWaterHeightAtLocation)
local MaxDistance = Config.Rod.MaxLaunchDistance

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoFishing then
            pcall(function()
                local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                local HRP = Char:FindFirstChild("HumanoidRootPart")
                if not HRP then return end

                local Tool = Char:FindFirstChildOfClass("Tool")

                
                if _G.SelectedRod and (not Tool or Tool.Name ~= _G.SelectedRod) then
                    local backpackTool = LocalPlayer.Backpack:FindFirstChild(_G.SelectedRod)
                    if backpackTool then
                        Char.Humanoid:EquipTool(backpackTool)
                        Tool = backpackTool
                    end
                end

                if Tool then
                    local waterHeight = GetWaterHeight(HRP.Position)
                    local _, hitPos = Workspace:FindPartOnRayWithIgnoreList(
                        Ray.new(Char.Head.Position, HRP.CFrame.LookVector * MaxDistance),
                        {Char, Workspace.Characters, Workspace.Enemies}
                    )
                    local TargetPos = hitPos and Vector3.new(hitPos.X, math.max(hitPos.Y, waterHeight), hitPos.Z)
                    local State = Tool:GetAttribute("State")
                    local ServerState = Tool:GetAttribute("ServerState")

                    if TargetPos and (State == "ReeledIn" or ServerState == "ReeledIn") then
                        FishingRequest:InvokeServer("StartCasting")
                        task.wait()
                        FishingRequest:InvokeServer("CastLineAtLocation", TargetPos, 100, true)
                    elseif ServerState == "Biting" then
                        FishingRequest:InvokeServer("Catching", true)
                        task.wait(0.1)
                        FishingRequest:InvokeServer("Catch", 1)
                    end
                end
            end)
        end
    end
end)


FishingQ = Tabs.Fish:AddToggle({
Name = "Auto Quest Fishing", 
Description = "",
Default = false,
Callback = function(Value)
    _G.AutoFishingQuest = Value
end})


local Players3 = game:GetService("Players")
local LocalPlayer3 = Players3.LocalPlayer
local ReplicatedStorage3 = game:GetService("ReplicatedStorage")
local RFJobsRemoteFunction3 = ReplicatedStorage3.Modules.Net:WaitForChild("RF/JobsRemoteFunction")

local function HasQuest3()
    local questGui = LocalPlayer3.PlayerGui:FindFirstChild("Quest") or LocalPlayer3.PlayerGui:FindFirstChild("QuestGui")
    if questGui and questGui:FindFirstChild("Container") and questGui.Container:FindFirstChild("QuestTitle") then
        return true
    end
    return false
end

task.spawn(function()
    while task.wait(1) do
        if _G.AutoFishingQuest then
            pcall(function()
                if not HasQuest3() then
                    RFJobsRemoteFunction3:InvokeServer("FishingNPC", "Angler", "AskQuest")
                end
            end)
        end
    end
end)


QuestToggle = Tabs.Fish:AddToggle({
    Name = "Auto Complete Quest",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoQuestComplete = Value

        if Value then
            pcall(function()
                Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest")
            end)
        end
    end
})


task.spawn(function()
    while task.wait(5) do 
        if _G.AutoQuestComplete then
            pcall(function()
                Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "FinishQuest")
            end)
        end
    end
end)


SellFishToggle = Tabs.Fish:AddToggle({
    Name = "Auto Sell Fish",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoSellFish = Value

        if Value then
            pcall(function()
                Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish")
            end)
        end
    end
})


task.spawn(function()
    while task.wait(5) do 
        if _G.AutoSellFish then
            pcall(function()
                Remotes.RFJobsRemoteFunction:InvokeServer("FishingNPC", "SellFish")
            end)
        end
    end
end)


SpamSkillZ = Tabs.Fish:AddToggle({
Name = "Auto Spam Skill Z", 
Description = "",
Default = false,
Callback = function(Value)
    _G.AutoSkillZ = Value
end})


local ReplicatedStorage4 = game:GetService("ReplicatedStorage")
local RFJobToolAbilities4 = ReplicatedStorage4.Modules.Net:WaitForChild("RF/JobToolAbilities")

task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSkillZ then
            pcall(function()
                RFJobToolAbilities4:InvokeServer("Z", true)
            end)
        end
    end
end)

TravelDress = Tabs.Quests:AddToggle({
Name = "Auto Quest Sea 2", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.TravelDres = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.TravelDres then
        if plr.Data.Level.Value >= 700 then
          if workspace.Map.Ice.Door.CanCollide == true and workspace.Map.Ice.Door.Transparency == 0 then
            replicated.Remotes.CommF_:InvokeServer("DressrosaQuestProgress","Detective")
		    EquipWeapon("Key")
		    repeat wait() _tp(CFrame.new(1347.7124, 37.3751602, -1325.6488)) until not _G.TravelDres or (Root.Position == CFrame.new(1347.7124, 37.3751602, -1325.6488).Position)
	      elseif workspace.Map.Ice.Door.CanCollide == false and workspace.Map.Ice.Door.Transparency == 1 then
            if Enemies:FindFirstChild("Ice Admiral") then
              for _,xz in pairs(Enemies:GetChildren()) do
                if xz.Name == "Ice Admiral" and Attack.Alive(xz) then
              	  repeat task.wait() Attack.Kill(xz,_G.TravelDres) until _G.TravelDres == false or xz.Humanoid.Health <= 0
                  replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
                end
              end
            else
              _tp(CFrame.new(1347.7124, 37.3751602, -1325.6488))
            end
	      else
		    replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
	      end
        end
      end
    end)
  end
end)
Zou = Tabs.Quests:AddToggle({
Name = "Auto Quest Sea 3", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoZou = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AutoZou then
   	    if plr.Data.Level.Value >= 1500 then
          if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 3 then
            if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess ~= nil then
              replicated.Remotes.CommF_:InvokeServer("F_","TravelZou")
              if replicated.Remotes.CommF_:InvokeServer("ZQuestProgress", "Check") == 0 then
                local v = GetConnectionEnemies("rip_indra")
                if v then
                  repeat wait() Attack.Kill(v,_G.AutoZou) until not _G.AutoZou or not v.Parent or v.Humanoid.Health <= 0
                  Check = 2
                  repeat wait()replicated.Remotes.CommF_:InvokeServer("F_","TravelZou")until Check == 1                   
                else
                  replicated.Remotes.CommF_:InvokeServer("F_","ZQuestProgress","Check") wait(.1)
                  replicated.Remotes.CommF_:InvokeServer("F_","ZQuestProgress","Begin")
                end
              elseif replicated.Remotes["CommF_"]:InvokeServer("ZQuestProgress", "Check") == 1 then
                replicated.Remotes.CommF_:InvokeServer("F_","TravelZou")
              else
                local v = GetConnectionEnemies("Don Swan")
                if v then
                  repeat wait() Attack.Kill(v,_G.AutoZou)until not _G.AutoZou or not v.Parent or v.Humanoid.Health<=0                  
                else
                  repeat wait() _tp(CFrame.new(2288.802, 15.1870775, 863.034607)) until not _G.AutoZou or (Root.Position == CFrame.new(2288.802, 15.1870775, 863.034607).Position)
                  if (Root.CFrame == CFrame.new(2288.802, 15.1870775, 863.034607)) then notween(CFrame.new(2288.802, 15.1870775, 863.034607)) end
                end
              end
            else
            if replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
              TabelDevilFruitStore = {}
              TabelDevilFruitOpen = {}
              for i,v in pairs(replicated.Remotes["CommF_"]:InvokeServer("getInventoryFruits")) do
                for i1,v1 in pairs(v) do
                  if i1 == "Name" then table.insert(TabelDevilFruitStore,v1)end
                end
              end
              for i,v in next, game.ReplicatedStorage:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do
                if v.Price >= 1000000 then table.insert(TabelDevilFruitOpen,v.Name) end
              end
              for i,DevilFruitOpenDoor in pairs(TabelDevilFruitOpen) do
                for i1,DevilFruitStore in pairs(TabelDevilFruitStore) do
                  if DevilFruitOpenDoor == DevilFruitStore and replicated.Remotes.CommF_:InvokeServer("GetUnlockables").FlamingoAccess == nil then
                    if not plr.Backpack:FindFirstChild(DevilFruitStore) then
                      replicated.Remotes.CommF_:InvokeServer("F_","LoadFruit",DevilFruitStore)
                    else
                      replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","1")
                      replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","2")
                      replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","3")
                    end
                  end
                end
              end
                replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","1")
                replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","2")
                replicated.Remotes.CommF_:InvokeServer("F_","TalkTrevor","3")
              end
            end
          else
            if replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 0 then
              if string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "Swan Pirates") and string.find(plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, "50") and plr.PlayerGui.Main.Quest.Visible == true then                
                local v = GetConnectionEnemies("Swan Pirate")
                if v then
                  pcall(function() repeat wait() Attack.Kill(v,_G.AutoZou) until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoZou == false or plr.PlayerGui.Main.Quest.Visible == false end)                    
                else
                  _tp(CFrame.new(1057.92761, 137.614319, 1242.08069))
                end
              else
                _tp(CFrame.new(-456.28952, 73.0200958, 299.895966))
              end
            elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 1 then
              local v = GetConnectionEnemies("Jeremy")
              if v then
                repeat wait() Attack.Kill(v,_G.AutoZou) until not v.Parent or v.Humanoid.Health <= 0 or _G.AutoZou == false
              else
                _tp(CFrame.new(2099.88159, 448.931, 648.997375))
              end
            elseif replicated.Remotes.CommF_:InvokeServer("BartiloQuestProgress","Bartilo") == 2 then
              repeat wait() _tp(CFrame.new(-1836, 11, 1714)) until not _G.AutoZou or (Root.Position == CFrame.new(-1836, 11, 1714).Position)
              if (Root.CFrame == CFrame.new(-1836, 11, 1714)) then notween(CFrame.new(-1836, 11, 1714))end
              notween(CFrame.new(-1850.49329, 13.1789551, 1750.89685))
              wait(.1)
              notween(CFrame.new(-1858.87305, 19.3777466, 1712.01807))
              wait(.1)
              notween(CFrame.new(-1803.94324, 16.5789185, 1750.89685))
              wait(.1)
              notween(CFrame.new(-1858.55835, 16.8604317, 1724.79541))
              wait(.1)
              notween(CFrame.new(-1869.54224, 15.987854, 1681.00659))
              wait(.1)
              notween(CFrame.new(-1800.0979, 16.4978027, 1684.52368))
              wait(.1)
              notween(CFrame.new(-1819.26343, 14.795166, 1717.90625))
              wait(.1)
              notween(CFrame.new(-1813.51843, 14.8604736, 1724.79541))
            end
          end
        end
      end
    end)
  end
end)




