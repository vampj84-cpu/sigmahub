-- ============================================
-- MODULE 11k: Travel / Teleport Tab
-- ============================================

Tabs.Travel:AddSection("Travel - Worlds")

Tabs.Travel:AddButton({
Name = "Travel East Blue (World 1)", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("TravelMain")
end})
Tabs.Travel:AddButton({
Name = "Travel Dressrosa (World 2)", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("TravelDressrosa")
end})
Tabs.Travel:AddButton({
Name = "Travel Zou (World 3)", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("TravelZou")
end})
Tabs.Travel:AddSection("Travel - Island")
Location = {}
for i,v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do  
  table.insert(Location ,v.Name)
end
Travelllll = Tabs.Travel:AddDropdown({
Name = "Select Travelling",
Description = "",
Options = Location,
Callback = function(Value)
  _G.Island = Value
end})
GoIsland = Tabs.Travel:AddToggle({
Name = "Auto Travel", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Teleport = Value
  if Value then
    for i,v in pairs(workspace["_WorldOrigin"].Locations:GetChildren()) do
      if v.Name == _G.Island then
        repeat wait()
	     _tp(v.CFrame * CFrame.new(0, 30, 0)) 
        until not _G.Teleport or Root.CFrame == v.CFrame
      end
    end
  end
end
})

Tabs.Travel:AddSection("Travel - Portal")
if World1 then
  Location_Portal = {
    "Sky",
    "UnderWater"
  }
elseif World2 then
  Location_Portal = {
    "SwanRoom",
    "Cursed Ship"
  }
elseif World3 then
  Location_Portal = {
    "Castle On The Sea",
    "Mansion Cafe",
    "Hydra Teleport",
    "Canvendish Room",
    "Temple of Time"
  }
end

PortalTP = Tabs.Travel:AddDropdown({
Name = "Select Portal",
Options = Location_Portal,
Callback = function(Value)
  _G.Island_PT = Value
end})
Tabs.Travel:AddButton({
Name = "requestEntrance", 
Description = "",
Callback = function()
  if _G.Island_PT == "Sky" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-7894, 5547, -380))
  elseif _G.Island_PT == "UnderWater" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(61163, 11, 1819))
  elseif _G.Island_PT == "SwanRoom" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(2285, 15, 905))
  elseif _G.Island_PT == "Cursed Ship" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(923, 126, 32852))
  elseif _G.Island_PT == "Castle On The Sea" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5097.93164, 316.447021, -3142.66602, -0.405007899, -4.31682743e-08, 0.914313197, -1.90943332e-08, 1, 3.8755779e-08, -0.914313197, -1.76180437e-09, -0.405007899))
  elseif _G.Island_PT == "Mansion Cafe" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
  elseif _G.Island_PT == "Hydra Teleport" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5643.45263671875, 1013.0858154296875, -340.51025390625))
  elseif _G.Island_PT == "Canvendish Room" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5314.54638671875, 22.562219619750977, -127.06755065917969))
  elseif _G.Island_PT == "Temple of Time" then
    replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(28310.0234, 14895.1123, 109.456741, -0.469690144, -2.85620132e-08, -0.882831335, -3.23509219e-08, 1, -1.51411736e-08, 0.882831335, 2.14487486e-08, -0.469690144))
  end
end})

Tabs.Travel:AddSection("Travel - NPCs")
for _, v in pairs(replicated.NPCs:GetChildren()) do table.insert(NPCList, v.Name)end
NPCsPos = Tabs.Travel:AddDropdown({
Name = "Select NPCs",
Options = NPCList,
Callback = function(Value)
  NPClist = Value
end})
GoNPCs = Tabs.Travel:AddToggle({
Name = "Auto Tween to NPC", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.TPNpc = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.TPNpc then
	 pcall(function()
       for __, v in pairs(replicated.NPCs:GetChildren()) do
       if v.Name == NPClist then _tp(v.HumanoidRootPart.CFrame) end
       end                	   	   
	 end)
    end
  end
end)

