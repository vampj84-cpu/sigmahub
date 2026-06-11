-- ============================================
-- MODULE 11e: Race / Mirage Tab
-- ============================================

Tabs.Race:AddSection("Mystic Island / Full Moon")
local FullMOOn = Tabs.Race:AddParagraph("FullMoon Status", "")
local Ismirage = Tabs.Race:AddParagraph("Mirage Island Status", "")
spawn(function()
    while wait(0.2) do
        if workspace.Map:FindFirstChild("MysticIsland") or workspace._WorldOrigin.Locations:FindFirstChild("Mirage Island") then
            Ismirage:SetDesc("Mirage Island : True")
        else
            Ismirage:SetDesc("Mirage Island : False")
        end
    end
end)
spawn(function()
    while wait(0.2) do
        pcall(function()
            local moon8 = "http://www.roblox.com/asset/?id=9709150401"
            local moon7 = "http://www.roblox.com/asset/?id=9709150086"
            local moon6 = "http://www.roblox.com/asset/?id=9709149680"
            local moon5 = "http://www.roblox.com/asset/?id=9709149431"
            local moon4 = "http://www.roblox.com/asset/?id=9709149052"
            local moon3 = "http://www.roblox.com/asset/?id=9709143733"
            local moon2 = "http://www.roblox.com/asset/?id=9709139597"
            local moon1 = "http://www.roblox.com/asset/?id=9709135895"
            local moon = Getmoon()
            
            if moon == moon1 then
                FullMOOn:SetDesc("Moon : 0 / 8")
            elseif moon == moon2 then
                FullMOOn:SetDesc("Moon : 1 / 8")
            elseif moon == moon3 then
                FullMOOn:SetDesc("Moon : 2 / 8")
            elseif moon == moon4 then
                FullMOOn:SetDesc("Moon : 3 / 8 [ Next Night ]")
            elseif moon == moon5 then
                FullMOOn:SetDesc("Moon : 4 / 8 [ Full Moon ]")
            elseif moon == moon6 then
                FullMOOn:SetDesc("Moon : 5 / 8 [ Last Night ]")
            elseif moon == moon7 then
                FullMOOn:SetDesc("Moon : 6 / 8")
            elseif moon == moon8 then
                FullMOOn:SetDesc("Moon : 7 / 8")
            end
        end)
    end
end)
Tabs.Race:AddToggle({
Name = "Auto Find Mirage Island", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.FindMirage = Value
end})
spawn(function()
  while wait() do
    if _G.FindMirage then 
      pcall(function()
        if not workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island", true) then                
          local myBoat = CheckBoat()
          if not myBoat then
            local buyBoatCFrame = CFrame.new(-16927.451, 9.086, 433.864)
            TeleportToTarget(buyBoatCFrame)
            if (buyBoatCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 then replicated.Remotes.CommF_:InvokeServer("BuyBoat", _G.SelectedBoat) end
          else
            if plr.Character.Humanoid.Sit == false then
              local boatSeatCFrame = myBoat.VehicleSeat.CFrame * CFrame.new(0, 1, 0)
              _tp(boatSeatCFrame)
            else            
              repeat wait()
                local targetDestination = CFrame.new(-10000000, 31, 37016.25)
                if CheckEnemiesBoat() or CheckTerrorShark() or CheckPirateGrandBrigade() then
                  _tp(CFrame.new(-10000000, 150, 37016.25))
                else
                  _tp(CFrame.new(-10000000, 31, 37016.25))
                end
              until not _G.FindMirage or (targetDestination.Position - plr.Character.HumanoidRootPart.Position).Magnitude <= 10 or workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island") or plr.Character.Humanoid.Sit == false plr.Character.Humanoid.Sit = false
            end
          end
        else
          _tp(workspace.Map.MysticIsland.Center.CFrame*CFrame.new(0,300,0))
        end
      end)
    end
  end
end)
Tabs.Race:AddToggle({
    Name = "Esp Mirage Island",
    Description = "",
    Value = false,
    Callback = function(Value)
        MirageIslandESP = Value
        if MirageIslandESP then
            task.spawn(function()
                while MirageIslandESP do
                    UpdateIslandMirageESP()
                    task.wait(1)
                end
            end)
        else
            UpdateIslandMirageESP()
        end
    end
})
Tabs.Race:AddToggle({
    Name = "Auto Tween To Mirage Island",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoMysticIsland = Value
    end
})

spawn(function()
    while task.wait(0.1) do
        pcall(function()
            if _G.AutoMysticIsland then
                for _, location in pairs(game:GetService("Workspace")._WorldOrigin.Locations:GetChildren()) do
                    if location.Name == "Mirage Island" then
                        topos(location.CFrame * CFrame.new(0, 333, 0))
                    end
                end
            end
        end)
    end
end)
Tabs.Race:AddToggle({
Name = "Auto Tween To Highest Point", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.HighestMirage = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.HighestMirage then 
      pcall(function()
      if workspace["_WorldOrigin"].Locations:FindFirstChild("Mirage Island",true) then _tp(workspace.Map.MysticIsland.Center.CFrame*CFrame.new(0,400,0))end
      end)
    end
  end
end)
Tabs.Race:AddToggle({
Name = "Auto Collect Gear", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.TPGEAR = Value
end})
spawn(function()
  pcall(function()
    while wait(0.1) do
      if _G.TPGEAR then
        for i,v in pairs(workspace.Map:FindFirstChild('MysticIsland'):GetChildren()) do
          if v.Name == "Part" then
            if v.ClassName == "MeshPart" then _tp(v.CFrame) end
          end
        end
      end
    end
  end)
end)
Tabs.Race:AddToggle({
Name = "Change Transparency can see", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.can = Value
end})
spawn(function()
  pcall(function()
    while wait(Sec) do
      if _G.can then
        for i,v in pairs(workspace.Map:FindFirstChild('MysticIsland'):GetChildren()) do
          if v.Name == "Part" then
            if v.ClassName == "MeshPart" then
              v.Transparency = 0
            else 
              v.Transparency = 1
            end
          end
        end
      end
    end
  end)
end)
Tabs.Race:AddToggle({
Name = "Auto Tween Advanced Fruit Dealer", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Addealer = Value
end})
spawn(function()
  while wait() do
    if _G.Addealer then
	  pcall(function()
	    for _,v in pairs(replicated.NPCs:GetChildren()) do
	    if v.Name == "Advanced Fruit Dealer" then _tp(v.HumanoidRootPart.CFrame) end
        end   	   
	 end)
    end
  end
end)
Tabs.Race:AddToggle({
Name = "Auto Collect Mirage Chest", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.FarmChestM = Value
end})
spawn(function()
  while wait(.2) do
    if _G.FarmChestM then
      pcall(function()
        if workspace.Map.MysticIsland.Chests:FindFirstChild("DiamondChest") or workspace.Map.MysticIsland.Chests:FindFirstChild("FragChest") then
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
        end
      end)
    end
  end
end)


Tabs.Race:AddButton({
Name = "Talk With Stone", 
Description = "",
Callback = function()
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Begin")
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Check")
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Teleport")
  replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("RaceV4Progress","Continue")
end})
Tabs.Race:AddToggle({
Name = "Auto Look At Moon", 
Description = "", 
Default = false,
Callback = function(Value)
  LookM = Value
end})
function MoveCamtoMoon()
workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position,Lighting:GetMoonDirection() + workspace.CurrentCamera.CFrame.Position)
plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position,Lighting:GetMoonDirection() + plr.Character.HumanoidRootPart.CFrame.Position)
end
task.spawn(function()
  while task.wait() do
    if LookM then
      MoveCamtoMoon()
      wait(.1)
      replicated.Remotes.CommE:FireServer("ActivateAbility")
    end
  end
end)

Tabs.Race:AddToggle({
    Name = "Look Moon + Auto V3", 
    Description = "",
    Default = false,
    Callback = function(Value)
        LookMV3 = Value
    end
})

function MoveCamtoMoon()
    local moonDir = Lighting:GetMoonDirection()
    workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + moonDir)
    plr.Character.HumanoidRootPart.CFrame = CFrame.new(plr.Character.HumanoidRootPart.Position, plr.Character.HumanoidRootPart.Position + moonDir)
end

task.spawn(function()
    while task.wait(0.1) do
        if LookMV3 then
            MoveCamtoMoon()
            replicated.Remotes.CommE:FireServer("ActivateAbility")            
            UIS:SendKeyEvent(true, "T", false, game)
            wait(0.5)
            UIS:SendKeyEvent(false, "T", false, game)
        end
    end
end)

Tabs.Race:AddSection("Upgrade Races V2 And V3")
RaceMink = Tabs.Race:AddToggle({
Name = "Auto Upgrade Mink", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Mink = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Mink then
        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= 2 then
          if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then
            replicated.Remotes.CommF_:InvokeServer("Alchemist","2")
          elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then
            if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then
              _tp(workspace.Flower1.CFrame)
            elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then
              _tp(workspace.Flower2.CFrame)
            elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then
              local v = GetConnectionEnemies("Swan Pirate")
              if v then repeat wait() Attack.Kill(v,_G.Auto_Mink) until GetBP("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Mink == false
              else _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))end            
            end        
          elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then
	        replicated.Remotes.CommF_:InvokeServer("Alchemist","3")
	      end
        elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then
          replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")
        elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then
		  _G.AutoFarmChest = true
	    else
	      _G.AutoFarmChest = false
        end
      end
    end)
  end
end)
RaceHuman = Tabs.Race:AddToggle({
Name = "Auto Upgrade Human", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Human = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Human then
        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= -2 then
	     if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then
		  replicated.Remotes.CommF_:InvokeServer("Alchemist","2")
		elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then
		  if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then
		    _tp(workspace.Flower1.CFrame)
		  elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then
		    _tp(workspace.Flower2.CFrame)
		  elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then
		    local v = GetConnectionEnemies("Swan Pirate")
            if v then repeat wait() Attack.Kill(v,_G.Auto_Human) until plr.Backpack:FindFirstChild("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Human == false
		    else _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))end
		  end
		  elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then
		    replicated.Remotes.CommF_:InvokeServer("Alchemist","3")
		  end
		  elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then
		    replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")
		  elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then
		  local v = GetConnectionEnemies(Human_v3_Mob[1])
          if v then repeat wait()Attack.Kill(v,_G.Auto_Human)until v.Humanoid.Health <= 0 or not v.Parent or not _G.Auto_Human			           
	      else _tp(CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625))
		  end		      
		  local v = GetConnectionEnemies(Human_v3_Mob[2])
          if v then repeat wait()Attack.Kill(v,_G.Auto_Human)until v.Humanoid.Health <= 0 or not v.Parent or not _G.Auto_Human			           
	      else _tp(CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109))
		  end		      
		  local v = GetConnectionEnemies(Human_v3_Mob[3])
          if v then repeat wait()Attack.Kill(v,_G.Auto_Human)until v.Humanoid.Health <= 0 or not v.Parent or not _G.Auto_Human			           
          else _tp(CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407))
	      end		      		
        end
      end
    end)
  end
end)
RaceSky = Tabs.Race:AddToggle({
Name = "Auto Upgrade Angel", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Skypiea = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Skypiea then
        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= -2 then
	      if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then
		    replicated.Remotes.CommF_:InvokeServer("Alchemist","2")
		  elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then
		    if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then
		      _tp(workspace.Flower1.CFrame)
		    elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then
		      _tp(workspace.Flower2.CFrame)
		    elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then
		      local v = GetConnectionEnemies("Swan Pirate")
		      if v then
			    repeat wait()Attack.Kill(v,_G.Auto_Skypiea)until plr.Backpack:FindFirstChild("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Skypiea == false
		      else
		        _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
		      end
		    end
	      elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then
            replicated.Remotes.CommF_:InvokeServer("Alchemist","3")
          end
		  elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then
	        replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")
	    elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then
	      for i,v in pairs(game.Players:GetChildren()) do
            if v.Name ~= plr.Name and tostring(v.Data.Race.Value) == "Skypiea" then
		      repeat task.wait() _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,8,0) * CFrame.Angles(math.rad(-45),0,0))until v.Humanoid.Health <= 0 or _G.Auto_Skypiea == false
	        end
	      end
        end          
      end
    end)
  end
end)
RaceFish = Tabs.Race:AddToggle({
Name = "Auto Upgrade FishMan", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Fish = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Fish then
        if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") ~= -2 then
	      if replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 0 then
		    replicated.Remotes.CommF_:InvokeServer("Alchemist","2")
		  elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 1 then
	        if not plr.Backpack:FindFirstChild("Flower 1") and not plr.Character:FindFirstChild("Flower 1") then
		      _tp(workspace.Flower1.CFrame)
	        elseif not plr.Backpack:FindFirstChild("Flower 2") and not plr.Character:FindFirstChild("Flower 2") then
	          _tp(workspace.Flower2.CFrame)
	        elseif not plr.Backpack:FindFirstChild("Flower 3") and not plr.Character:FindFirstChild("Flower 3") then
	          local v = GetConnectionEnemies("Swan Pirate")
		      if v then
			    repeat wait()Attack.Kill(v,_G.Auto_Fish)until plr.Backpack:FindFirstChild("Flower 3") or not v.Parent or v.Humanoid.Health <= 0 or _G.Auto_Fish == false
	          else
		       _tp(CFrame.new(980.0985107421875, 121.331298828125, 1287.2093505859375))
	          end
            end
	      elseif replicated.Remotes.CommF_:InvokeServer("Alchemist","1") == 2 then
            replicated.Remotes.CommF_:InvokeServer("Alchemist","3")
          end
        elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 0 then
	      replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","2")
	    elseif replicated.Remotes.CommF_:InvokeServer("Wenlocktoad","1") == 1 then
          warn("Sea Beast Soon")
        end
      end
    end)
  end
end)


Tabs.Race:AddSection("Trials Quest V4")
local CheckTier = Tabs.Race:AddParagraph("Tiers V4 Status", "")
spawn(function()
    pcall(function()
        while wait(0.2) do
            CheckTier:SetDesc("Tiers - V4 : " .. " " .. plr.Data.Race.C.Value)
        end
    end)
end)
PullLv = Tabs.Race:AddToggle({
Name = "Auto Pull Lever", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Lver = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.Lver then
      pcall(function()
        for x,c in pairs(workspace.Map["Temple of Time"]:GetDescendants()) do
        if c.Name == "ProximityPrompt" then fireproximityprompt(c,math.huge)end
        end
      end)
    end
  end
end)
Train = Tabs.Race:AddToggle({
Name = "Auto Train V4", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AcientOne = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.AcientOne then
        local BonesTable = {"Reborn Skeleton","Living Zombie","Demonic Soul","Posessed Mummy"}
	    for i=1,#BonesTable do
          if plr.Character:FindFirstChild("RaceEnergy").Value == 1 then
            vim1:SendKeyEvent(true, "Y", false, game)
            replicated.Remotes.CommF_:InvokeServer("UpgradeRace","Buy")
            _tp(CFrame.new(-8987.041015625, 215.862060546875, 5886.71044921875))
	      elseif plr.Character:FindFirstChild("RaceTransformed").Value == false then
	        local v = GetConnectionEnemies(BonesTable)
	        if v then repeat wait() Attack.Kill(v, _G.AcientOne) until _G.AcientOne == false or v.Humanoid.Health <= 0 or not v.Parent
		    else _tp(CFrame.new(-9495.6806640625, 453.58624267578125, 5977.3486328125)) 
		    end
	      end
        end
      end
    end)
  end
end)

Tabs.Race:AddButton({
    Name = "Teleport to Temple of Time",
    Description = "",
    Callback = function()
        local plr = game:GetService("Players").LocalPlayer
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        end

        if not game:GetService("Workspace").Map:FindFirstChild("Temple of Time") and World3 then
            local stash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")
            if stash and stash:FindFirstChild("Temple of Time") then
                stash["Temple of Time"].Parent = workspace.Map
            end
        end
    end
})
Tabs.Race:AddButton({
Name = "Teleport to Ancient One", 
Description = "",
Callback = function()
        local plr = game:GetService("Players").LocalPlayer
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

        if hrp then
            hrp.CFrame = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)
        end

        if not game:GetService("Workspace").Map:FindFirstChild("Temple of Time") and World3 then
            local stash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")
            if stash and stash:FindFirstChild("Temple of Time") then
                stash["Temple of Time"].Parent = workspace.Map
            end
        end
        
        task.wait(2)

        tween(CFrame.new(28981.552734375, 14888.4267578125, - 120.245849609375))
    end
})
Tabs.Race:AddButton({
Name = "Teleport to Ancient Clock", 
Description = "",
Callback = function()
        local plr = game:GetService("Players").LocalPlayer
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")

        local pos1 = CFrame.new(28286.35546875, 14895.3017578125, 102.62469482421875)

        local pos2 = CFrame.new(29549, 15069, -88)

        if hrp then
            hrp.CFrame = pos1
        end

        task.delay(2, function()
            _tp(pos2)
        end)

        if not workspace.Map:FindFirstChild("Temple of Time") and World3 then
            local stash = game:GetService("ReplicatedStorage"):FindFirstChild("MapStash")
            if stash and stash:FindFirstChild("Temple of Time") then
                stash["Temple of Time"].Parent = workspace.Map
            end
        end
    end
})
Doors = Tabs.Race:AddToggle({
Name = "Auto Teleport to Race Doors", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.TPDoor = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.TPDoor then
	    if tostring(plr.Data.Race.Value) == "Mink" then
          _tp(CFrame.new(29020.66015625, 14889.4267578125, -379.2682800292969))
	    elseif tostring(plr.Data.Race.Value) == "Fishman" then
          _tp(CFrame.new(28224.056640625, 14889.4267578125, -210.5872039794922))
	    elseif tostring(plr.Data.Race.Value) == "Cyborg" then
          _tp(CFrame.new(28492.4140625, 14894.4267578125, -422.1100158691406))
	    elseif tostring(plr.Data.Race.Value) == "Skypiea" then
          _tp(CFrame.new(28967.408203125, 14918.0751953125, 234.31198120117188))
	    elseif tostring(plr.Data.Race.Value) == "Ghoul" then
          _tp(CFrame.new(28672.720703125, 14889.1279296875, 454.5961608886719))
	    elseif tostring(plr.Data.Race.Value) == "Human" then
          _tp(CFrame.new(29237.294921875, 14889.4267578125, -206.94955444335938))
	    end
      end
    end)
  end
end)                   
Trials = Tabs.Race:AddToggle({
Name = "Auto Complete Trial Race", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Complete_Trials = Value
end})
GetSeaBeastTrial = function()
  if not workspace.Map:FindFirstChild("FishmanTrial") then return nil end
  if workspace["_WorldOrigin"].Locations:FindFirstChild("Trial of Water") then FishmanTrial = workspace["_WorldOrigin"].Locations:FindFirstChild("Trial of Water") end
  if FishmanTrial then
    for _,v in next, workspace.SeaBeasts:GetChildren() do
      if v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - FishmanTrial.Position).Magnitude <= 1500 then
      if v.Health.Value > 0 then return v end
      end
    end
  end
end
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Complete_Trials then
        if tostring(plr.Data.Race.Value) == "Mink" then
          notween(workspace.Map.MinkTrial.Ceiling.CFrame * CFrame.new(0,-20,0))
	   end
      end
    end)
  end
end)
spawn(function()
  while wait(Sec) do
    pcall(function() 
      if _G.Complete_Trials then
	    if tostring(plr.Data.Race.Value) == "Fishman" then
	      if GetSeaBeastTrial() then            
            repeat task.wait()
              spawn(function()_tp(CFrame.new(GetSeaBeastTrial().HumanoidRootPart.Position.X,game:GetService("Workspace").Map["WaterBase-Plane"].Position.Y + 300,GetSeaBeastTrial().HumanoidRootPart.Position.Z))end)
		      MousePos = GetSeaBeastTrial().HumanoidRootPart.Position
              Useskills("Melee","Z")
	          Useskills("Melee","X")
	          Useskills("Melee","C")
              wait(.1)
              Useskills("Sword","Z")
              Useskills("Sword","X")
              wait(.1)
              Useskills("Blox Fruit","Z")
              Useskills("Blox Fruit","X")
              Useskills("Blox Fruit","C")
              wait(.1)
              Useskills("Gun","Z")
              Useskills("Gun","X")
            until _G.Complete_Trials == false or not GetSeaBeastTrial()
          end          
	    end
      end
    end)
  end
end)
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Complete_Trials then
        if tostring(plr.Data.Race.Value) == "Cyborg" then
         _tp(workspace.Map.CyborgTrial.Floor.CFrame * CFrame.new(0,500,0))
   	   end
      end
    end)
  end
end)
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Complete_Trials then
        if tostring(plr.Data.Race.Value) == "Skypiea" then
          notween(workspace.Map.SkyTrial.Model.FinishPart.CFrame)
  	   end
      end
    end)
  end
end)
spawn(function()
  while wait(.1) do   
    pcall(function()
      if _G.Complete_Trials then
	    if tostring(plr.Data.Race.Value) == "Human" or tostring(plr.Data.Race.Value) == "Ghoul" then	      
	      local TrialsTables = {"Ancient Vampire","Ancient Zombie"}
	      local v = GetConnectionEnemies(TrialsTables)
          if v then repeat wait() Attack.Kill(v, _G.Complete_Trials)until _G.Complete_Trials == false or not v.Parent or v.Humanoid.Health <= 0 end		
        end
      end
    end)
  end
end)
AutoKill = Tabs.Race:AddToggle({
Name = "Auto Kill Player After Trial", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Defeating = Value
end})
spawn(function()
  while task.wait(Sec) do
    pcall(function()
      if _G.Defeating then
	    for _, v in pairs(workspace.Characters:GetChildren()) do
          if v.Name ~= plr.Name then
            if v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") and v.Parent and (Root.Position - v.HumanoidRootPart.Position).Magnitude <= 250 then
              repeat task.wait() EquipWeapon(_G.SelectWeapon) _tp(v.HumanoidRootPart.CFrame * CFrame.new(0,0,15)) sethiddenproperty(plr, "SimulationRadius", math.huge)until _G.Defeating == false or v.Humanoid.Health <= 0 or not v.Parent or not v:FindFirstChild("HumanoidRootPart") or not v:FindFirstChild("Humanoid")
            end
          end
        end
      end
    end)
  end
end)

