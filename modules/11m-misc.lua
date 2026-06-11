-- ============================================
-- MODULE 11m: Misc Tab (Server, Graphics, God Config,
--              FastAttack, HitRegistration)
-- ============================================

Tabs.Misc:AddSection("Server - Function")
Tabs.Misc:AddButton({
    Name = "Redeem All Codes",
    Description = "",
    Callback = function()
        local codes = {
            "LIGHTNINGABUSE","1LOSTADMIN","ADMINFIGHT","GIFTING_HOURS","NOMOREHACK",
            "BANEXPLOIT","WildDares","BossBuild","GetPranked","EARN_FRUITS",
            "SUB2GAMERROBOT_RESET1","KITT_RESET","Bignews","CHANDLER","Fudd10",
            "fudd10_v2","Sub2UncleKizaru","FIGHT4FRUIT","kittgaming","TRIPLEABUSE",
            "Sub2CaptainMaui","Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK",
            "Starcodeheo","Bluxxy","SUB2GAMERROBOT_EXP1","Sub2NoobMaster123",
            "Sub2Daigrock","Axiore","TantaiGaming","StrawHatMaine","Sub2OfficialNoobie",
            "TheGreatAce","JULYUPDATE_RESET","ADMINHACKED","SEATROLLING","24NOADMIN",
            "ADMIN_TROLL","NEWTROLL","SECRET_ADMIN","staffbattle","NOEXPLOIT",
            "NOOB2ADMIN","CODESLIDE","fruitconcepts","krazydares"
        }

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
        local RedeemRemote = RemotesFolder:FindFirstChild("Redeem")

        if not RedeemRemote then
            return
        end

        for _, code in ipairs(codes) do
            task.wait(0)
            pcall(function()
                if RedeemRemote.InvokeServer then
                    RedeemRemote:InvokeServer(code)
                else
                    RedeemRemote:FireServer(code)
                end
            end)
        end
    end
})
Tabs.Misc:AddButton({
Name = "Rejoin Server", 
Description = "",
Callback = function()
  game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end})
Tabs.Misc:AddButton({
    Name = "Hop Server",
    Description = "",
    Callback = function()
        task.spawn(function()
            local HttpService = game:GetService("HttpService")
            local TeleportService = game:GetService("TeleportService")
            local PlaceId = game.PlaceId
            local Players = game:GetService("Players")

            local success, servers = pcall(function()
                local url = "https://games.roblox.com/v1/games/"..PlaceId.."/servers/Public?sortOrder=Asc&limit=100"
                local response = game:HttpGet(url)
                return HttpService:JSONDecode(response).data
            end)

            if success and servers then
                local targetServer
                for _, s in pairs(servers) do
                    if s.playing < s.maxPlayers then
                        targetServer = s.id
                    end
                end

                if targetServer then
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(PlaceId, targetServer, Players.LocalPlayer)
                    end)
                end
            end
        end)
    end
})
Tabs.Misc:AddButton({
Name = "Hop to Lowest Players", 
Description = "",
Callback = function()
  local Http = game:GetService("HttpService")
  local TPS = game:GetService("TeleportService")
  local Api = "https://games.roblox.com/v1/games/"
  local _place = game.PlaceId
  local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
   function ListServers(cursor)
     local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
     return Http:JSONDecode(Raw)
   end
   local Server, Next; repeat
   local Servers = ListServers(Next)
   Server = Servers.data[1]
   Next = Servers.nextPageCursor
  until Server
  TPS:TeleportToPlaceInstance(_place,Server.id,plr)
end})

Tabs.Misc:AddButton({
Name = "Hop to Lowest Pings Server", 
Description = "",
Callback = function()
local HTTPService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local StatsService = game:GetService("Stats")
local function fetchServersData(placeId, limit)
    local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?limit=%d", placeId, limit)
    local success, response = pcall(function()
        return HTTPService:JSONDecode(game:HttpGet(url))
    end)
  if success and response and response.data then
	return response.data
  end
    return nil
  end
  local placeId = game.PlaceId
  local serverLimit = 100
  local servers = fetchServersData(placeId, serverLimit)
  if not servers then return end
  local lowestPingServer = servers[1]
  for _, server in pairs(servers) do
    if server["ping"] < lowestPingServer["ping"] and server.maxPlayers > server.playing then
      lowestPingServer = server
    end
  end
  local commonLoadTime = 0.5
  task.wait(commonLoadTime)
  local pingThreshold = 100
  local serverStats = StatsService.Network.ServerStatsItem
  local dataPing = serverStats["Data Ping"]:GetValueString()
  local pingValue = tonumber(dataPing:match("(%d+)"))
  if pingValue >= pingThreshold then
    TeleportService:TeleportToPlaceInstance(placeId, lowestPingServer.id)
  else
  end
end})

local replicated = game:GetService("ReplicatedStorage")

Tabs.Misc:AddTextBox({
    Name = "Input Job Id",
    Placeholder = "Job ID",
    ClearOnFocus = true,
    Callback = function(Value)
        getgenv().Job = Value
    end
})

Tabs.Misc:AddButton({
    Name = "Teleport [Job ID]", 
    Callback = function()
        if getgenv().Job and getgenv().Job ~= "" then
            game:GetService("TeleportService")
                :TeleportToPlaceInstance(
                    game.PlaceId,
                    getgenv().Job,
                    game.Players.LocalPlayer
                )
        end
    end
})
Tabs.Misc:AddButton({
Name = "Copy JobID", 
Description = "",
Callback = function()
  setclipboard(tostring(game.JobId))
end})

Tabs.Misc:AddSection("Player Gui / Others")

Tabs.Misc:AddButton({
Name = "Open Awakenings Expert", 
Description = "",
Callback = function()
  plr.PlayerGui.Main.AwakeningToggler.Visible = true
end})
Tabs.Misc:AddButton({
Name = "Open Title Selection", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("getTitles",true)
  plr.PlayerGui.Main.Titles.Visible = true
end})
DisbleChat = Tabs.Misc:AddToggle({
Name = "Disable Chat GUI", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.Rechat = Value
  if  _G.Rechat == true then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, false)    
  elseif _G.chat == false then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)    
  end
end
})
DisbleLeaderB = Tabs.Misc:AddToggle({
Name = "Disable Leader Board GUI", 
Description = "", 
Default = false,
Callback = function(Value)
  ReLeader = Value
  if ReLeader == true then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)   
  elseif ReLeader == false then
    local StarterGui = game:GetService('StarterGui')
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)   
  end
end
})
Tabs.Misc:AddButton({
Name = "Set Pirate Team", 
Description = "",
Callback = function()
  Pirates()
end})  
Tabs.Misc:AddButton({
Name = "Set Marine Team", 
Description = "",
Callback = function()
  Marines()
end})
UnPortal = Tabs.Misc:AddToggle({
Name = "Unlock All Portals", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.PortalUnLock = Value
end})
spawn(function()
  while wait(Sec) do
    pcall(function()
      if _G.PortalUnLock then        
         if Attack.Pos(CstlePos_Miti,8) then
           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-12471.169921875, 374.94024658203, -7551.677734375))
         elseif Attack.Pos(Man3Pos_Miti,8) then
           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5072.08984375, 314.5412902832, -3151.1098632812))
         elseif Attack.Pos(HydraPos_Miti,8) then                    
           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(5748.7587890625, 610.44982910156, -267.81704711914))
         elseif Attack.Pos(HydratoCastle,8) then                   
           replicated.Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5072.08984375, 314.5412902832, -3151.1098632812))
        end
      end
    end)
  end
end)

Tabs.Misc:AddSection("Graphics / Haki Stats")

HakiSt = {"State 0","State 1","State 2","State 3","State 4","State 5"}
HakiStat = Tabs.Misc:AddDropdown({
Name = "Select Haki States",
Options = HakiSt,
Callback = function(Value)
  _G.SelectStateHaki = Value
end})
Tabs.Misc:AddButton({
Name = "ChangeBusoStage", 
Description = "",
Callback = function()
  if _G.SelectStateHaki == "State 0" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",0)
  elseif _G.SelectStateHaki == "State 1" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",1)
  elseif _G.SelectStateHaki == "State 2" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",2)
  elseif _G.SelectStateHaki == "State 3" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",3)
  elseif _G.SelectStateHaki == "State 4" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",4)
  elseif _G.SelectStateHaki == "State 5" then
    replicated.Remotes.CommF_:InvokeServer("ChangeBusoStage",5)
  end
end})
rtxM = Tabs.Misc:AddToggle({
Name = "Turn on RTX Mode", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.RTXMode = Value
  local a = game.Lighting
  local c = Instance.new("ColorCorrectionEffect", a)
  local e = Instance.new("ColorCorrectionEffect", a)
  OldAmbient = a.Ambient
  OldBrightness = a.Brightness
  OldColorShift_Top = a.ColorShift_Top
  OldBrightnessc = c.Brightness
  OldContrastc = c.Contrast
  OldTintColorc = c.TintColor
  OldTintColore = e.TintColor    
  if not _G.RTXMode then return end
  while _G.RTXMode do wait()
    a.Ambient = Color3.fromRGB(33, 33, 33)
    a.Brightness = 0.3
    c.Brightness = 0.176
    c.Contrast = 0.39
    c.TintColor = Color3.fromRGB(217, 145, 57)
    game.Lighting.FogEnd = 999
    if not plr.Character.HumanoidRootPart:FindFirstChild("PointLight") then
      local a2 = Instance.new("PointLight")
      a2.Parent = plr.Character.HumanoidRootPart
      a2.Range = 15
      a2.Color = Color3.fromRGB(217, 145, 57)
    end
    if not _G.RTXMode then
      a.Ambient = OldAmbient
      a.Brightness = OldBrightness
      a.ColorShift_Top = OldColorShift_Top
      c.Contrast = OldContrastc
      c.Brightness = OldBrightnessc
      c.TintColor = OldTintColorc
      e.TintColor = OldTintColore
      game.Lighting.FogEnd = 2500
      plr.Character.HumanoidRootPart:FindFirstChild("PointLight"):Destroy()
    end
  end
end
})
Tabs.Misc:AddButton({
Name = "Turn on Fast Mode", 
Description = "",
Callback = function()
  for _,zx in next, workspace:GetDescendants() do
  if table.find(Past, zx.ClassName) then  zx.Material = "Plastic" end
  end
end})
Tabs.Misc:AddButton({
Name = "Turn on Low CPU", 
Description = "",
Callback = function()
  LowCpu()
end})
Tabs.Misc:AddButton({
Name = "Turn on increase Boats", 
Description = "",
Callback = function()
  for _, v in pairs(workspace.Boats:GetDescendants()) do
    if table.find(ListSeaBoat, v.Name) and tostring(v.Owner.Value) == tostring(plr.Name) then              
      v.VehicleSeat.MaxSpeed = 350
      v.VehicleSeat.Torque = 0.2
      v.VehicleSeat.TurnSpeed = 5
      v.VehicleSeat.HeadsUpDisplay = true
    end
  end
end})
Tabs.Misc:AddButton({
Name = "Remove Sky Fog", 
Description = "",
Callback = function()
  if Lighting:FindFirstChild("LightingLayers") then Lighting.LightingLayers:Destroy() end
  if Lighting:FindFirstChild("SeaTerrorCC") then Lighting.SeaTerrorCC:Destroy() end
  if Lighting:FindFirstChild("FantasySky") then Lighting.FantasySky:Destroy() end
end})

Tabs.Misc:AddSection("Configure - God")
Tabs.Misc:AddButton({
Name = "Rain Fruits (Client)", 
Description = "",
Callback = function()
  for i, v in pairs(game:GetObjects("rbxassetid://14759368201")[1]:GetChildren()) do
    v.Parent = game.Workspace.Map
    v:MoveTo(plr.Character.PrimaryPart.Position + Vector3.new(math.random(-50, 50), 100, math.random(-50, 50)))
    if v.Fruit:FindFirstChild("AnimationController") then
      v.Fruit:FindFirstChild("AnimationController"):LoadAnimation(v.Fruit:FindFirstChild("Idle")):Play()
    end
    v.Handle.Touched:Connect(function(otherPart)
      if otherPart.Parent == plr.Character then
        v.Parent = plr.Backpack
        plr.Character.Humanoid:EquipTool(v)
      end
    end)
  end
end})
briggt1 = Tabs.Misc:AddToggle({
Name = "Turn on Full Bright", 
Description = "", 
Default = false,
Callback = function(Value)
  bright = Value
  if Value == true then
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
    Lighting.ColorShift_Top = Color3.new(1, 1, 1)
  else
    Lighting.Ambient = Color3.new(0, 0, 0)
    Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
    Lighting.ColorShift_Top = Color3.new(0, 0, 0)
  end  
end
})


DayN = Tabs.Misc:AddDropdown({
Name = "Select Time",
Description = "",
Options = {"Day", "Night"},
Default = Day,
Callback = function(Value)
  _G.SelectDN = Value
end})
dayornight = Tabs.Misc:AddToggle({
Name = "Turn on Time", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.daylightN = Value
end})
task.spawn(function()
  while task.wait() do
    if _G.daylightN then
      if _G.SelectDN == "Day" then
        Lighting.ClockTime = 12
      elseif _G.SelectDN == "Night" then
        Lighting.ClockTime = 0
      end
    end
  end
end)
walkWater = Tabs.Misc:AddToggle({
Name = "Turn on Walk on Water", 
Description = "", 
Default = true,
Callback = function(Value)
  _G.WalkWater_Part = Value
  if _G.WalkWater_Part then
    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
  else
    game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
  end
end
})
iceWalk = Tabs.Misc:AddToggle({
Name = "Turn on Ice Walk", 
Description = "", 
Default = false,
Callback = function(Value)
  _G.WalkWater = Value
end})
spawn(function()
  while task.wait() do
    if _G.WalkWater then
      pcall(function()
	   if plr.Character and plr.Character:FindFirstChild("LeftFoot") then
	   local upval0 = replicated.Assets.Models.IceSpikes4:Clone()
        upval0.Parent = workspace
        upval0.Size = Vector3.new(3+math.random(10,12),1.7,3+math.random(10,12))
        upval0.Color = Color3.fromRGB(128,187,219)
        upval0.CFrame = CFrame.new(plr.Character.Head.Position.X,-3.8,plr.Character.Head.Position.Z)*CFrame.Angles((math.random()-0.5)*0.06, math.random()*7,(math.random()-0.5)*0.07)
        local var85={};
        var85.Size=Vector3.new(0,0.3,0)
        local var3=TW:Create(upval0,TweenInfo.new(2,Enum.EasingStyle.Quad,Enum.EasingDirection.In),var85)
        var3.Completed:Connect(function()
          upval0:Destroy()
        end)
          var3:Play()
	    end	
      end)
    end
  end
end)
local player = game.Players.LocalPlayer
local function IsEntityAlive(entity)
    if not entity then return false end
    local humanoid = entity:FindFirstChild("Humanoid")
    return humanoid and humanoid.Health > 0
end
local function GetEnemiesInRange(character, range)
    local enemies = game:GetService("Workspace").Enemies:GetChildren()
    local players = game:GetService("Players"):GetPlayers()
    local targets = {}
    local playerPos = character:GetPivot().Position
    for _, enemy in ipairs(enemies) do
        local rootPart = enemy:FindFirstChild("HumanoidRootPart")
        if rootPart and IsEntityAlive(enemy) then
            local distance = (rootPart.Position - playerPos).Magnitude
            if distance <= range then
                table.insert(targets, enemy)
            end
        end
    end
    for _, otherPlayer in ipairs(players) do
        if otherPlayer ~= player and otherPlayer.Character then
            local rootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart and IsEntityAlive(otherPlayer.Character) then
                local distance = (rootPart.Position - playerPos).Magnitude
                if distance <= range then
                    table.insert(targets, otherPlayer.Character)
                end
            end
        end
    end
    return targets
end
function AttackNoCoolDown()
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if not character then return end
    local equippedWeapon = nil
    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Tool") then
            equippedWeapon = item
            break
        end
    end
    if not equippedWeapon then return end
    local enemiesInRange = GetEnemiesInRange(character, 60)
    if #enemiesInRange == 0 then return end
    local storage = game:GetService("ReplicatedStorage")
    local modules = storage:FindFirstChild("Modules")
    if not modules then return end
    local attackEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterAttack")
    local hitEvent = storage:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RE/RegisterHit")
    if not attackEvent or not hitEvent then return end
    local targets, mainTarget = {}, nil
    for _, enemy in ipairs(enemiesInRange) do
        if not enemy:GetAttribute("IsBoat") then
            local HitboxLimbs = {"RightLowerArm", "RightUpperArm", "LeftLowerArm", "LeftUpperArm", "RightHand", "LeftHand"}
            local head = enemy:FindFirstChild(HitboxLimbs[math.random(#HitboxLimbs)]) or enemy.PrimaryPart
            if head then
                table.insert(targets, { enemy, head })
                mainTarget = head
            end
        end
    end
    if not mainTarget then return end
    attackEvent:FireServer(0)
    local playerScripts = player:FindFirstChild("PlayerScripts")
    if not playerScripts then return end
    local localScript = playerScripts:FindFirstChildOfClass("LocalScript")
    while not localScript do
        playerScripts.ChildAdded:Wait()
        localScript = playerScripts:FindFirstChildOfClass("LocalScript")
    end
    local hitFunction
    if getsenv then
        local success, scriptEnv = pcall(getsenv, localScript)
        if success and scriptEnv then
            hitFunction = scriptEnv._G.SendHitsToServer
        end
    end
    local successFlags, combatRemoteThread = pcall(function()
        return require(modules.Flags).COMBAT_REMOTE_THREAD or false
    end)
    if successFlags and combatRemoteThread and hitFunction then
        hitFunction(mainTarget, targets)
    elseif successFlags and not combatRemoteThread then
        hitEvent:FireServer(mainTarget, targets)
    end
end
CameraShakerR = require(game.ReplicatedStorage.Util.CameraShaker)
CameraShakerR:Stop()
get_Monster=function()for a,b in pairs(workspace.Enemies:GetChildren())do local c=b:FindFirstChild("UpperTorso")or b:FindFirstChild("Head")if b:FindFirstChild("HumanoidRootPart",true)and c then if(b.Head.Position-plr.Character.HumanoidRootPart.Position).Magnitude<=50 then return true,c.Position end end end;for a,d in pairs(workspace.SeaBeasts:GetChildren())do if d:FindFirstChild("HumanoidRootPart")and d:FindFirstChild("Health")and d.Health.Value>0 then return true,d.HumanoidRootPart.Position end end;for a,d in pairs(workspace.Enemies:GetChildren())do if d:FindFirstChild("Health")and d.Health.Value>0 and d:FindFirstChild("VehicleSeat")then return true,d.Engine.Position end end end
Actived=function()local a=game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")for b,c in next,getconnections(a.Activated)do if typeof(c.Function)=='function'then getupvalues(c.Function)end end end
task.spawn(function()
  RunSer.Heartbeat:Connect(function()
    pcall(function()      
      if not _G.Seriality then return end      
      AttackNoCoolDown() 
      local Pretool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
      local ToolTip = Pretool.ToolTip
      local MobAura, Mon = get_Monster()      
      if ToolTip == "Blox Fruit" then
        if MobAura then           
          local LeftClickRemote = Pretool:FindFirstChild('LeftClickRemote');
          if LeftClickRemote then Actived() LeftClickRemote:FireServer(Vector3.new(0.01,-500,0.01),1,true);LeftClickRemote:FireServer(false)end
        end     		                         
      end      
    end)
  end)
end)
local FastAttackModule = {}
local HitRegistrationModule = {}
local MainController = {}

local GameService = game
local Players = GameService:GetService("Players")
local RunService = GameService:GetService("RunService")
local ReplicatedStorage = GameService:GetService("ReplicatedStorage")
local Workspace = GameService:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local function SafeWaitForChild(parent, childName)
    local success, result = pcall(function()
        return parent:WaitForChild(childName)
    end)
    return result
end

local Enemies = SafeWaitForChild(Workspace, "Enemies")
local Characters = SafeWaitForChild(Workspace, "Characters")
local Modules = SafeWaitForChild(ReplicatedStorage, "Modules")
local Net = SafeWaitForChild(Modules, "Net")

FastAttackModule.Rate = 0.000000002
FastAttackModule.Enabled = true

function FastAttackModule.IsAlive(target)
    local humanoid = target:FindFirstChild("Humanoid")
    if humanoid and humanoid.Health > 0 then
        return true
    end
    return false
end

function FastAttackModule.GetNearbyTargets(character, folder)
    local characterPosition = character:GetPivot().Position
    local nearbyTargets = {}
    local children = folder:GetChildren()
    
    for i = 1, #children do
        local target = children[i]
        local humanoid = target:FindFirstChild("Humanoid")
        local rootPart = target:FindFirstChild("HumanoidRootPart")
        
        if humanoid and rootPart and humanoid.Health > 0 then
            local distance = (rootPart.Position - characterPosition).Magnitude
            if distance <= 60 then
                table.insert(nearbyTargets, target)
            end
        end
    end
    return nearbyTargets
end

function FastAttackModule.GetTargetParts(targetList)
    local result = {}
    local count = #targetList
    
    for i = 1, count do
        local target = targetList[i]
        local head = target:FindFirstChild("Head") or target.PrimaryPart
        if head then
            table.insert(result, {target, head})
        end
    end
    return result
end

function FastAttackModule.GetAllTargets(character)
    local enemies = FastAttackModule.GetNearbyTargets(character, Enemies)
    local otherCharacters = FastAttackModule.GetNearbyTargets(character, Characters)
    
    local allTargets = {}
    for i = 1, #enemies do
        table.insert(allTargets, enemies[i])
    end
    for i = 1, #otherCharacters do
        table.insert(allTargets, otherCharacters[i])
    end
    return allTargets
end

function FastAttackModule.ExecuteFastAttack()
    local character = LocalPlayer.Character
    if not character then return end
    
    local tool = character:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    local targets = FastAttackModule.GetAllTargets(character)
    if #targets < 1 then return end
    
    local targetParts = FastAttackModule.GetTargetParts(targets)
    if #targetParts < 1 then return end
    
    local attackRemote = Net["RE/RegisterAttack"]
    local hitRemote = Net["RE/RegisterHit"]
    
    attackRemote:FireServer(FastAttackModule.Rate)
    local targetHead = targetParts[1][2]
    hitRemote:FireServer(targetHead, targetParts)
end

local AttackRemoteTarget
local AttackRemoteId

local function InitializeHitRegistration()
    local foldersToCheck = {
        ReplicatedStorage.Util,
        ReplicatedStorage.Common,
        ReplicatedStorage.Remotes,
        ReplicatedStorage.Assets,
        ReplicatedStorage.FX
    }

    for _, folder in ipairs(foldersToCheck) do
        local children = folder:GetChildren()
        
        for _, child in ipairs(children) do
            if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
                AttackRemoteTarget = child
                AttackRemoteId = child:GetAttribute("Id")
            end
        end

        folder.ChildAdded:Connect(function(child)
            if child:IsA("RemoteEvent") and child:GetAttribute("Id") then
                AttackRemoteTarget = child
                AttackRemoteId = child:GetAttribute("Id")
            end
        end)
    end
end

InitializeHitRegistration()

function HitRegistrationModule.Execute()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    local hitTargets = {}

    local function ScanFolder(folder)
        local children = folder:GetChildren()
        for i = 1, #children do
            local target = children[i]
            local humanoid = target:FindFirstChild("Humanoid")
            local rootPart = target:FindFirstChild("HumanoidRootPart")
            
            if humanoid and rootPart and humanoid.Health > 0 and target ~= character then
                local distance = (rootPart.Position - humanoidRootPart.Position).Magnitude
                if distance <= 60 then
                    local targetChildren = target:GetChildren()
                    for _, child in ipairs(targetChildren) do
                        if child:IsA("BasePart") then
                            table.insert(hitTargets, {target, child})
                        end
                    end
                end
            end
        end
    end

    ScanFolder(Enemies)
    ScanFolder(Characters)

    local tool = character:FindFirstChildOfClass("Tool")
    
    if #hitTargets > 0 and tool and (tool:GetAttribute("WeaponType") == "Melee" or tool:GetAttribute("WeaponType") == "Sword") then
        local seed = Modules.Net.seed:InvokeServer()
        
        local attackRemote = Net["RE/RegisterAttack"]
        local hitRemote = Net["RE/RegisterHit"]
        
        attackRemote:FireServer()
        
        local targetHead = hitTargets[1][1]:FindFirstChild("Head")
        if not targetHead then return end

        hitRemote:FireServer(targetHead, hitTargets, {})
        
        if AttackRemoteTarget then
            local remoteCode = "RE/RegisterHit"
            local encryptionKey = math.floor(Workspace:GetServerTimeNow() / 10 % 10) + 1
            
            local encodedString = string.gsub(remoteCode, ".", function(char)
                return string.char(bit32.bxor(string.byte(char), encryptionKey))
            end)

            local finalId = bit32.bxor(AttackRemoteId + 909090, seed * 2)
            
            cloneref(AttackRemoteTarget):FireServer(
                encodedString,
                finalId,
                targetHead,
                hitTargets
            )
        end
    end
end

local function DisableCameraShake()
    local cameraModule = require(ReplicatedStorage.Util.CameraShaker)
    cameraModule:Stop()
end

local function StartMainLoops()
    task.spawn(function()
        while task.wait(FastAttackModule.Rate) do
            FastAttackModule.ExecuteFastAttack()
        end
    end)

    RunService.Heartbeat:Connect(function()
        pcall(HitRegistrationModule.Execute)
    end)
end

StartMainLoops()
