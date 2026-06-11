-- ============================================
-- MODULE 11i: Raids / Fruits Tab
-- ============================================

Tabs.Raids:AddSection("Fruits Options")

local function formatNumber(number)
    local str = tostring(number)
    repeat
        local replaced, count = str:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        str = replaced
    until count == 0
    return str
end

local function getFruitStock()
    local resultStr = "Advance Fruit Stock\n"
    local success, advanceFruits = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits", true)
    end)

    if not success or not advanceFruits then
        resultStr = resultStr .. "- Error while retrieving data.\n"
    else
        local hasFruit = false
        for _, fruit in pairs(advanceFruits) do
            if fruit.OnSale then
                hasFruit = true
                resultStr = resultStr .. fruit.Name .. " - $" .. formatNumber(fruit.Price) .. "\n"
            end
        end
        if not hasFruit then
            resultStr = resultStr .. "- No fruit.\n"
        end
    end

    resultStr = resultStr .. "\nNormal Fruit Stock\n"
    local success2, normalFruits = pcall(function()
        return game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
    end)

    if success2 and normalFruits then
        local hasFruit = false
        for _, fruit in pairs(normalFruits) do
            if fruit.OnSale then
                hasFruit = true
                resultStr = resultStr .. fruit.Name .. " - $" .. formatNumber(fruit.Price) .. "\n"
            end
        end
        if not hasFruit then
            resultStr = resultStr .. "- No fruit.\n"
        end
    else
        resultStr = resultStr .. "- Error while retrieving data.\n"
    end

    return resultStr
end

local stockParagraph = Tabs.Raids:AddParagraph("Stock Fruit", "Loading...")

task.spawn(function()
    while task.wait(60) do
        pcall(function()
            stockParagraph:SetDesc(getFruitStock())
        end)
    end
end)

pcall(function()
    stockParagraph:SetDesc(getFruitStock())
end)


RandomFF = Tabs.Raids:AddToggle({
Name = "Auto Random Fruit", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Random_Auto = Value
end})
spawn(function()
  while wait(Sec) do
   	pcall(function()
      if _G.Random_Auto then replicated.Remotes.CommF_:InvokeServer("Cousin","Buy") end 
    end)
  end
end)
DropF = Tabs.Raids:AddToggle({
Name = "Auto Drop Fruit", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.DropFruit = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.DropFruit then
      pcall(function() DropFruits() end)
    end
  end
end)
StoredF = Tabs.Raids:AddToggle({
Name = "Auto Store Fruit", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.StoreF = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.StoreF then
      pcall(function() UpdStFruit() end)
    end
  end
end)
TwF = Tabs.Raids:AddToggle({
Name = "Auto Tween to Fruit", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.TwFruits = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.TwFruits then
      pcall(function()
        for _,x1 in pairs(workspace:GetChildren()) do
	    if string.find(x1.Name, "Fruit") then _tp(x1.Handle.CFrame) end
	    end
      end)
    end
  end
end)
BringF = Tabs.Raids:AddToggle({
Name = "Auto Collect Fruit", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.InstanceF = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.InstanceF then
      pcall(function() collectFruits(_G.InstanceF) end)
    end
  end
end)

Tabs.Raids:AddDropdown({
    Name = "Select Fruit Shop",
    Options = {
        "Rocket-Rocket", "Spin-Spin", "Blade-Blade", "Spring-Spring",
        "Bomb-Bomb", "Smoke-Smoke", "Spike-Spike", "Flame-Flame",
        "Ice-Ice", "Sand-Sand", "Dark-Dark", "Eagle-Eagle",
        "Diamond-Diamond", "Light-Light", "Rubber-Rubber", "Ghost-Ghost",
        "Magma-Magma", "Quake-Quake", "Buddha-Buddha", "Love-Love",
        "Creation-Creation", "Spider-Spider", "Sound-Sound", "Phoenix-Phoenix",
        "Portal-Portal", "Lightning-Lightning", "Pain-Pain", "Blizzard-Blizzard",
        "Gravity-Gravity", "T-Rex-T-Rex", "Mammoth-Mammoth", "Dough-Dough",
        "Shadow-Shadow", "Venom-Venom", "Gas-Gas", "Control-Control",
        "Spirit-Spirit", "Leopard-Leopard", "Yeti-Yeti", "Kitsune-Kitsune",
        "Dragon-Dragon"
    },
    Callback = function(Value)
        getgenv().SelectFruit = Value
    end
})
Tabs.Raids:AddToggle({
    Name = "Auto Buy Fruit Shop",
    Default = false,
    Callback = function(Value)
        getgenv().AutoBuyFruitSniper = Value
    end
})
spawn(function()
    pcall(function()
        while wait() do
            if getgenv().AutoBuyFruitSniper then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("GetFruits")
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PurchaseRawFruit", getgenv().SelectFruit)
            end
        end
    end)
end)

Tabs.Raids:AddSection("Dungeon Event / Raiding")
DungeonTables = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"}
Q = Tabs.Raids:AddDropdown({
Name = "Select Chip",
Description = "",
Options = DungeonTables,
Callback = function(Value)
  _G.SelectChip = Value
end})
Q = Tabs.Raids:AddToggle({
Name = "Auto Select Dungeon Chip", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoSelectDungeon = Value
end})
Tabs.Raids:AddToggle({
    Name = "Get Fruit In Inventory Below 1M",
    Default = false,
    Callback = function(Value)
        getgenv().AutoGetFruit = Value
    end
})
spawn(function()
    while wait() do
        pcall(function()
            if getgenv().AutoGetFruit then
                local fruits = {
                    "Rocket-Rocket", "Spin-Spin", "Chop-Chop", "Spring-Spring", "Bomb-Bomb", "Smoke-Smoke",
                    "Spike-Spike", "Flame-Flame", "Falcon-Falcon", "Ice-Ice", "Sand-Sand", "Dark-Dark",
                    "Ghost-Ghost", "Diamond-Diamond", "Light-Light", "Rubber-Rubber", "Barrier-Barrier"
                }
                for _, fruit in ipairs(fruits) do
                    local args = {
                        [1] = "LoadFruit",
                        [2] = fruit
                    }
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack(args))
                end
            end
        end)
    end
end)
Tabs.Raids:AddButton({
Name = "Buy Dungeon Chips [Beli]", 
Description = "",
Callback = function()
  if not GetBP("Special Microchip") then replicated.Remotes.CommF_:InvokeServer("RaidsNpc","Select",_G.SelectChip) end
end})
Tabs.Raids:AddButton({
Name = "Buy Dungeon Chips [Devil Fruit]", 
Description = "",
Callback = function()
  if GetBP("Special Microchip") then return end
  local FruitPrice = {}
  local FruitStore = {}
  for i,v in next,replicated:WaitForChild("Remotes").CommF_:InvokeServer("GetFruits") do
    if v.Price <= 490000 then table.insert(FruitPrice,v.Name) end 
  end    
  for _,y in pairs(FruitPrice) do    
    for i,v in pairs(DungeonTables) do 
      if not GetBP("Special Microchip") then     
        replicated.Remotes.CommF_:InvokeServer("LoadFruit",tostring(y))	      
	    replicated.Remotes.CommF_:InvokeServer("RaidsNpc","Select",_G.SelectChip)	
	  end            
    end    
  end
end})


AutoChipBeli = Tabs.Raids:AddToggle({
    Name = "Auto Buy Chip [Beli]",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.AutoChipBeli = Value
end
})

task.spawn(function()
    while task.wait(1) do
        if _G.AutoChipBeli then
            pcall(function()
                if not GetBP("Special Microchip") then
                    replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                end
            end)
        end
    end
end)


AutoChipFruit = Tabs.Raids:AddToggle({
    Name = "Auto Buy Chip [Devil Fruit]",
    Description = "",
    Default = false,
    Callback = function(Value)
    _G.AutoChipFruit = Value
end
})

task.spawn(function()
    while task.wait(1) do
        if _G.AutoChipFruit then
            pcall(function()
                if not GetBP("Special Microchip") then
                    local fruits = replicated.Remotes.CommF_:InvokeServer("GetFruits")
                    local cheapest = nil
                    for _, data in pairs(fruits) do
                        if data.Price <= 490000 then
                            cheapest = data.Name
                            break
                        end
                    end
                    if cheapest then
                        replicated.Remotes.CommF_:InvokeServer("LoadFruit", tostring(cheapest))
                        replicated.Remotes.CommF_:InvokeServer("RaidsNpc", "Select", _G.SelectChip)
                    end
                end
            end)
        end
    end
end)


StartR = Tabs.Raids:AddToggle({
    Name = "Auto Start Raid",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Auto_StartRaid = Value
    end
})

task.spawn(function()
    while task.wait(Sec) do
        if not _G.Auto_StartRaid then continue end

        pcall(function()
            local plr = game.Players.LocalPlayer
            local gui = plr:FindFirstChild("PlayerGui")
            local main = gui and gui:FindFirstChild("Main")
            local top = main and main:FindFirstChild("TopHUDList")

            if not top or top.RaidTimer.Visible then return end

            if not GetBP("Special Microchip") then return end

            if World2 then
                local btn = workspace.Map.CircleIsland.RaidSummon2.Button.Main
                if btn then
                    if btn:FindFirstChild("ProximityPrompt") then
                        fireproximityprompt(btn.ProximityPrompt)
                    elseif btn:FindFirstChild("ClickDetector") then
                        fireclickdetector(btn.ClickDetector)
                    end
                end
            end

            if World3 then
                local btn = workspace.Map["Boat Castle"].RaidSummon2.Button.Main
                if btn then
                    if btn:FindFirstChild("ProximityPrompt") then
                        fireproximityprompt(btn.ProximityPrompt)
                    elseif btn:FindFirstChild("ClickDetector") then
                        fireclickdetector(btn.ClickDetector)
                    end
                end
            end
        end)
    end
end)

Raiding = Tabs.Raids:AddToggle({
    Name = "Auto Raid + Next Island",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.Raiding = Value
    end
})

spawn(function()
    local locations = workspace["_WorldOrigin"].Locations
    local islands = {"Island 1","Island 2","Island 3","Island 4","Island 5"}
    local currentIsland = nil

    while task.wait(0.3) do
        if not _G.Raiding then continue end
         

        local gui = plr.PlayerGui.Main.TopHUDList.RaidTimer
        if not gui.Visible then continue end

        local char = plr.Character
        if not char then continue end

        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then continue end
        if hum.Sit or hum.PlatformStand or root.Anchored then continue end


        local closestDist = 999999
        for _,name in ipairs(islands) do
            local loc = locations:FindFirstChild(name)
            if loc then
                local dist = (root.Position - loc.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    currentIsland = name
                end
            end
        end

        if not currentIsland then continue end
        local islandPos = locations:FindFirstChild(currentIsland)
        if not islandPos then continue end


        local foundEnemies = false
        for _,mob in ipairs(workspace.Enemies:GetChildren()) do
            local eh = mob:FindFirstChild("Humanoid")
            local ehrp = mob:FindFirstChild("HumanoidRootPart")
            if eh and ehrp and eh.Health > 0 then
                if (ehrp.Position - islandPos.Position).Magnitude < 450 then
                    foundEnemies = true
                    repeat
                        task.wait()
                        Attack.Kill(mob, _G.Raiding)
                    until not _G.Raiding or not mob.Parent or eh.Health <= 0
                end
            end
        end


        if not foundEnemies then
            local idx = table.find(islands, currentIsland)
            if idx and islands[idx+1] then
                local nxt = locations:FindFirstChild(islands[idx+1])
                if nxt then
              
                    local safePos = nxt.CFrame * CFrame.new(0, 45, 120)
                    _tp(safePos)
                end
                currentIsland = islands[idx+1]
                task.wait(1)
            end
        end
    end
end)

Tabs.Raids:AddToggle({
Name = "Auto Awakening", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Auto_Awakener = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.Auto_Awakener then
        replicated.Remotes.CommF_:InvokeServer("Awakener","Check")
        replicated.Remotes.CommF_:InvokeServer("Awakener","Awaken")
      end
    end)
  end
end)	

Tabs.Raids:AddToggle({
    Name = "Auto Teleport To Lab",
    Default = false,
    Callback = function(Value)
        _G.TpLab = Value
        StopTween(_G.TpLab)
        while _G.TpLab do
            wait()
            if _G.TpLab then
                if World2 and _G.TpLab then
                    topos(CFrame.new(-6438.73535, 250.645355, -4501.50684))
                elseif World3 and _G.TpLab then
                    topos(CFrame.new(-5017.40869, 314.844055, -2823.0127,-0.925743818, 4.48217499e-08, -0.378151238,4.55503146e-09, 1, 1.07377559e-07,0.378151238, 9.7681621e-08, -0.925743818))
                end
            end
        end
    end
})

Tabs.Raids:AddSection("Items Law/Order Sword")

Tabs.Raids:AddButton({
Name = "Buy Microchip Law", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Microchip","2")
end})
Tabs.Raids:AddButton({
Name = "Start Law Raids", 
Description = "",
Callback = function()
  fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
end})

Tabs.Raids:AddToggle({
    Name = "Auto Buy Microchip Law", 
    Description = "",
    Default = false,
    Callback = function(Value)
        getgenv().AutoBuyMicrochipLaw = Value
    end
})

spawn(function()
    while task.wait(1) do  
        if getgenv().AutoBuyMicrochipLaw then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward","Microchip","2")
            end)
        end
    end
end)

Tabs.Raids:AddToggle({
    Name = "Auto Start Law Raids", 
    Description = "",
    Default = false,
    Callback = function(Value)
        getgenv().AutoStartLawRaids = Value
    end
})

spawn(function()
    while task.wait(1) do  
        if getgenv().AutoStartLawRaids then
            pcall(function()
                fireclickdetector(workspace.Map.CircleIsland.RaidSummon.Button.Main.ClickDetector)
            end)
        end
    end
end)

Tabs.Raids:AddToggle({
Name = "Auto Kill Law", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.AutoLawKak = Value
end})
spawn(function()
  while wait(Sec) do
    if _G.AutoLawKak then
      pcall(function()
        local v = GetConnectionEnemies("Order")
        if v then repeat task.wait() Attack.Kill(v, _G.AutoLawKak) until _G.AutoLawKak == false or not v.Parent or v.Humanoid.Health <= 0
        else _tp(CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875))
        end
      end)
    end
  end
end)

Tabs.Raids:AddSection("Raids Dungeons")

local plr = game.Players.LocalPlayer

local function GetHRP()
    local char = plr.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

Tabs.Raids:AddToggle({
    Name = "Auto Farm Dungeon",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoFarmDungeon = Value
    end
})

local FARM_RANGE = 5000

spawn(function()
    while task.wait(0.15) do
        if not _G.AutoFarmDungeon then continue end

        pcall(function()
            local plr = game.Players.LocalPlayer
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then return end

            for _, mob in pairs(workspace.Enemies:GetChildren()) do
                if not _G.AutoFarmDungeon then break end

                local mh = mob:FindFirstChild("Humanoid")
                local mhrp = mob:FindFirstChild("HumanoidRootPart")

                if mh and mhrp and mh.Health > 0 then
                    local dist = (mhrp.Position - hrp.Position).Magnitude
                    if dist <= FARM_RANGE then
                        repeat
                            task.wait()
                            Attack.Kill(mob, true)
                        until not _G.AutoFarmDungeon
                            or not mob.Parent
                            or mh.Health <= 0
                    end
                end
            end
        end)
    end
end)


Tabs.Raids:AddToggle({
    Name = "TP Exit (1)",
    Default = false,
    Callback = function(v)
        _G.TPFloor1 = v
    end
})


local tp1Done = false

local function GetCurrentFloor()
    local hrp = GetHRP()
    if not hrp then return end

    for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
        local exit = floor:FindFirstChild("ExitTeleporter")
        if exit and exit:FindFirstChild("Root") then
            if (hrp.Position - exit.Root.Position).Magnitude < 200 then
                return exit.Root
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.3) do
        if not _G.TPFloor1 then
            tp1Done = false
            continue
        end

        if not tp1Done then
            local root = GetCurrentFloor()
            if root then
                root = root.CFrame * CFrame.new(0,3,0)
                GetHRP().CFrame = root
                tp1Done = true
            end
        end
    end
end)

Tabs.Raids:AddToggle({
    Name = "TP Exit (2)",
    Default = false,
    Callback = function(v)
        _G.TPFloor2 = v
    end
})

local tp2Done = false

task.spawn(function()
    while task.wait(0.3) do
        if not _G.TPFloor2 then
            tp2Done = false
            continue
        end

        if tp2Done then continue end

        local hrp = GetHRP()
        if not hrp then continue end

        for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
            local ent = floor:FindFirstChild("EntranceTeleporter")
            local ext = floor:FindFirstChild("ExitTeleporter")

            if ent and ext and ent:FindFirstChild("Root") and ext:FindFirstChild("Root") then
                if (hrp.Position - ent.Root.Position).Magnitude < 100 then
                    hrp.CFrame = ext.Root.CFrame * CFrame.new(0,3,0)
                    tp2Done = true
                    break
                end
            end
        end
    end
end)

Tabs.Raids:AddToggle({
    Name = "TP Exit (3)",
    Default = false,
    Callback = function(v)
        _G.TPFloor3 = v
    end
})

local tp3Done = false

local function GetHighestFloor()
    local max
    for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
        local n = tonumber(floor.Name)
        if n and (not max or n > tonumber(max.Name)) then
            max = floor
        end
    end
    return max
end

task.spawn(function()
    while task.wait(0.3) do
        if not _G.TPFloor3 then
            tp3Done = false
            continue
        end

        if not tp3Done then
            local floor = GetHighestFloor()
            if floor and floor:FindFirstChild("ExitTeleporter")
            and floor.ExitTeleporter:FindFirstChild("Root") then

                GetHRP().CFrame =
                    floor.ExitTeleporter.Root.CFrame * CFrame.new(0,3,0)
                tp3Done = true
            end
        end
    end
end)

Tabs.Raids:AddToggle({
    Name = "TP Exit (4)",
    Default = false,
    Callback = function(v)
        _G.TPFloor4 = v
    end
})

local tp4Done = false

local function GetNearestExit()
    local hrp = GetHRP()
    if not hrp then return end

    local nearest, dist = nil, math.huge

    for _, floor in pairs(workspace.Map.Dungeon:GetChildren()) do
        local exit = floor:FindFirstChild("ExitTeleporter")
        if exit and exit:FindFirstChild("Root") then
            local d = (hrp.Position - exit.Root.Position).Magnitude
            if d < dist then
                dist = d
                nearest = exit.Root
            end
        end
    end
    return nearest
end

task.spawn(function()
    while task.wait(0.3) do
        if not _G.TPFloor4 then
            tp4Done = false
            continue
        end

        if not tp4Done then
            local root = GetNearestExit()
            if root then
                GetHRP().CFrame = root.CFrame * CFrame.new(0,3,0)
                tp4Done = true
            end
        end
    end
end)





