-- ============================================
-- MODULE 1: Core Initialization
-- ============================================

do
    ply = game.Players
    plr = ply.LocalPlayer
    Root = plr.Character.HumanoidRootPart
    replicated = game:GetService("ReplicatedStorage")
    Lv = game.Players.LocalPlayer.Data.Level.Value
    TeleportService = game:GetService("TeleportService")
    TW = game:GetService("TweenService")
    Lighting = game:GetService("Lighting")
    Enemies = workspace.Enemies
    vim1 = game:GetService("VirtualInputManager")
    vim2 = game:GetService("VirtualUser")
    TeamSelf = plr.Team
    RunSer = game:GetService("RunService")
    Stats = game:GetService("Stats")
    Energy = plr.Character.Energy.Value
    BringConnections = {}
    BossList = {}
    MaterialList = {}
    NPCList = {}
    shouldTween = false
    SoulGuitar = false
    KenTest = true
    debug = false
    Brazier1 = false
    Brazier2 = false
    Brazier3 = false
    Sec = 0.1
    ClickState = 0
    Num_self = 25
end


-- ============================================
-- MODULE 2: World Detection & Config Data
-- ============================================

repeat local start = plr.PlayerGui:WaitForChild("Main"):WaitForChild("Loading") and game:IsLoaded() wait() until start

World1 = game.PlaceId == 2753915549 or game.PlaceId == 85211729168715
World2 = game.PlaceId == 4442272183 or game.PlaceId == 79091703265657
World3 = game.PlaceId == 7449423635 or game.PlaceId == 100117331123089

sea1 = World1
sea2 = World2
sea3 = World3

Marines = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Marines") end
Pirates = function() replicated.Remotes.CommF_:InvokeServer("SetTeam","Pirates") end

if World1 then BossList = {"The Gorilla King","Bobby","The Saw","Yeti","Mob Leader","Vice Admiral","Saber Expert","Warden","Chief Warden","Swan","Magma Admiral","Fishman Lord","Wysper","Thunder God","Cyborg","Ice Admiral","Greybeard"}
elseif World2 then BossList = {"Diamond","Jeremy","Orbitus","Don Swan","Smoke Admiral","Awakened Ice Admiral","Tide Keeper","Darkbeard","Cursed Captain","Order"}
elseif World3 then BossList = {"Stone","Hydra Leader","Kilo Admiral","Captain Elephant","Beautiful Pirate","Cake Queen","Dough King","Longma","Soul Reaper","rip_indra True Form","Tyrant of the Skies"}
end

if World1 then MaterialList = {"Leather + Scrap Metal", "Angel Wings", "Magma Ore", "Fish Tail"}
elseif World2 then MaterialList = {"Leather + Scrap Metal", "Radioactive Material", "Ectoplasm", "Mystic Droplet", "Magma Ore", "Vampire Fang"}
elseif World3 then MaterialList = {"Scrap Metal", "Demonic Wisp", "Conjured Cocoa", "Dragon Scale", "Gunpowder", "Fish Tail", "Mini Tusk"}
end

local DungeonTables = {"Flame","Ice","Quake","Light","Dark","String","Rumble","Magma","Human: Buddha","Sand","Bird: Phoenix","Dough"}
local RenMon = {"Snow Lurker","Arctic Warrior","Hidden Key","Awakened Ice Admiral"}
local CursedTables = {["Mob"] = "Mythological Pirate",["Mob2"] = "Cursed Skeleton","Hell's Messenger",["Mob3"] = "Cursed Skeleton","Heaven's Guardian"}
local Past = {"Part","SpawnLocation","Terrain","WedgePart","MeshPart"}
local BartMon = {"Swan Pirate","Jeremy"}
local CitizenTable = {"Forest Pirate","Captain Elephant"}
local Human_v3_Mob = {"Fajita","Jeremy","Diamond"}
local AllBoats = {"Beast Hunter","Lantern","Guardian","Grand Brigade","Dinghy","Sloop","The Sentinel"}
local mastery1 = {"Cookie Crafter"}
local mastery2 = {"Reborn Skeleton"}
local PosMsList = {["Pirate Millionaire"] = CFrame.new(-712.8272705078125, 98.5770492553711, 5711.9541015625),["Pistol Billionaire"] = CFrame.new(-723.4331665039062, 147.42906188964844, 5931.9931640625),["Dragon Crew Warrior"] = CFrame.new(7021.50439453125, 55.76270294189453, -730.1290893554688),["Dragon Crew Archer"] = CFrame.new(6625, 378, 244),["Female Islander"] = CFrame.new(4692.7939453125, 797.9766845703125, 858.8480224609375),["Venomous Assailant"] = CFrame.new(4902, 670, 39), ["Marine Commodore"] = CFrame.new(2401, 123, -7589),["Marine Rear Admiral"] = CFrame.new(3588, 229, -7085),["Fishman Raider"] = CFrame.new(-10941, 332, -8760),["Fishman Captain"] = CFrame.new(-11035, 332, -9087),["Forest Pirate"] = CFrame.new(-13446, 413, -7760),["Mythological Pirate"] = CFrame.new(-13510, 584, -6987),["Jungle Pirate"] = CFrame.new(-11778, 426, -10592),["Musketeer Pirate"] = CFrame.new(-13282, 496, -9565),["Reborn Skeleton"] = CFrame.new(-8764, 142, 5963),["Living Zombie"] = CFrame.new(-10227, 421, 6161),["Demonic Soul"] = CFrame.new(-9579, 6, 6194),["Posessed Mummy"] = CFrame.new(-9579, 6, 6194),["Peanut Scout"] = CFrame.new(-1993, 187, -10103),["Peanut President"] = CFrame.new(-2215, 159, -10474),["Ice Cream Chef"] = CFrame.new(-877, 118, -11032),["Ice Cream Commander"] = CFrame.new(-877, 118, -11032),["Cookie Crafter"] = CFrame.new(-2021, 38, -12028),["Cake Guard"] = CFrame.new(-2024, 38, -12026),["Baking Staff"] = CFrame.new(-1932, 38, -12848),["Head Baker"] = CFrame.new(-1932, 38, -12848),["Cocoa Warrior"] = CFrame.new(95, 73, -12309),["Chocolate Bar Battler"] = CFrame.new(647, 42, -12401),["Sweet Thief"] = CFrame.new(116, 36, -12478),["Candy Rebel"] = CFrame.new(47, 61, -12889),["Ghost"] = CFrame.new(5251, 5, 1111)}

-- ============================================

-- MODULE 3: Remote Events & Weapon Management
-- ============================================

local Remotes = {
    RFJobsRemoteFunction = replicated.Modules.Net["RF/JobsRemoteFunction"],
    RFCraft = replicated:WaitForChild("Modules"):WaitForChild("Net"):WaitForChild("RF/Craft")
}

EquipWeapon = function(text)
    if not text then return end
    if plr.Backpack:FindFirstChild(text) then
        plr.Character.Humanoid:EquipTool(plr.Backpack:FindFirstChild(text))
    end
end

weaponSc = function(weapon)
    for __in, v in pairs(plr.Backpack:GetChildren()) do
        if v:IsA("Tool") then
            if v.ToolTip == weapon then EquipWeapon(v.Name) end
        end
    end
end

-- ============================================

-- MODULE 4: Combat System
-- ============================================

local Attack = {}
Attack.__index = Attack
Attack.Alive = function(model) if not model then return end local Humanoid = model:FindFirstChild("Humanoid") return Humanoid and Humanoid.Health > 0 end
Attack.Pos = function(model,dist) return (Root.Position - model.Position).Magnitude <= dist end
Attack.Dist = function(model,dist) return (Root.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude <= dist end
Attack.DistH = function(model,dist) return (Root.Position - model:FindFirstChild("HumanoidRootPart").Position).Magnitude > dist end

Attack.Kill = function(model,Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        EquipWeapon(_G.SelectWeapon)
        local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local ToolTip = Equipped.ToolTip
        if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(90),0)) else _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0) * CFrame.Angles(0,math.rad(180),0))end
        if RandomCFrame then wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30 ,0)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(.5)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))end
    end
end

Attack.Kill2 = function(model,Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        EquipWeapon(_G.SelectWeapon)
        local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local ToolTip = Equipped.ToolTip
        if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(90),0)) else _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,8) * CFrame.Angles(0,math.rad(180),0))end
        if RandomCFrame then wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30 ,0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))end
    end
end

Attack.KillSea = function(model,Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        EquipWeapon(_G.SelectWeapon)
        local Equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        local ToolTip = Equipped.ToolTip
        if ToolTip == "Blox Fruit" then _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,10,0) * CFrame.Angles(0,math.rad(90),0)) else notween(model.HumanoidRootPart.CFrame * CFrame.new(0,50,8)) wait(.85)notween(model.HumanoidRootPart.CFrame * CFrame.new(0,400,0)) wait(1)end
    end
end

Attack.Sword = function(model,Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        weaponSc("Sword")
        _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
        if RandomCFrame then wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(25, 30, 0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30 ,0)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(0, 30, 25)) wait(0.1)_tp(model.HumanoidRootPart.CFrame * CFrame.new(-25, 30, 0))end
    end
end

Attack.Mas = function(model,Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        if model.Humanoid.Health <= HealthM then
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,20,0))
            Useskills("Blox Fruit","Z")
            Useskills("Blox Fruit","X")
            Useskills("Blox Fruit","C")
        else
            weaponSc("Melee")
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
        end
    end
end

Attack.Masgun = function(model,Succes)
    if model and Succes then
        if not model:GetAttribute("Locked") then model:SetAttribute("Locked",model.HumanoidRootPart.CFrame) end
        PosMon = model:GetAttribute("Locked").Position
        BringEnemy()
        if model.Humanoid.Health <= HealthM then
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,35,8))
            Useskills("Gun","Z")
            Useskills("Gun","X")
        else
            weaponSc("Melee")
            _tp(model.HumanoidRootPart.CFrame * CFrame.new(0,30,0))
        end
    end
end

-- ============================================

-- MODULE 5: Stats System
-- ============================================

statsSetings = function(Num, value)
    if Num == "Melee" then
        if plr.Data.Points.Value ~= 0 then
            replicated.Remotes.CommF_:InvokeServer("AddPoint","Melee",value)
        end
    elseif Num == "Defense" then
        if plr.Data.Points.Value ~= 0 then
            replicated.Remotes.CommF_:InvokeServer("AddPoint","Defense",value)
        end
    elseif Num == "Sword" then
        if plr.Data.Points.Value ~= 0 then
            replicated.Remotes.CommF_:InvokeServer("AddPoint","Sword",value)
        end
    elseif Num == "Gun" then
        if plr.Data.Points.Value ~= 0 then
            replicated.Remotes.CommF_:InvokeServer("AddPoint","Gun",value)
        end
    elseif Num == "Devil" then
        if plr.Data.Points.Value ~= 0 then
            replicated.Remotes.CommF_:InvokeServer("AddPoint","Demon Fruit",value)
        end
    end
end

-- ============================================

-- MODULE 6: Enemy Management (Bring, Skills, Hook)
-- ============================================

BringEnemy = function(Mon)
    if not _B then return end
    if not Mon then
        local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local closestDist = math.huge
        for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            local root = enemy:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    Mon = enemy
                end
            end
        end
        if not Mon then return end
    end
    local AreaMob = false
    local function Mobs(enemy)
        local hum = enemy:FindFirstChildOfClass("Humanoid")
        local root = enemy:FindFirstChild("HumanoidRootPart")
        return hum and root and hum.Health > 0, root, hum
    end
    local function Network(part)
        if isnetworkowner then
            return isnetworkowner(part)
        end
        return part.ReceiveAge == 0 and not part.Anchored and part.Velocity.Magnitude > 0
    end
    pcall(function()
        if sethiddenproperty then
            sethiddenproperty(plr, "SimulationRadius", math.huge)
        end
        local targetPos = Mon.HumanoidRootPart.Position
        for _, v in ipairs(workspace.Enemies:GetChildren()) do
            if v ~= Mon then
                local alive, root, hum = Mobs(v)
                if alive and v.Name == Mon.Name then
                    local distance = (root.Position - targetPos).Magnitude
                    if distance <= 3000 then
                        local bv = root:FindFirstChild("BodyVelocity")
                        if not bv then
                            bv = Instance.new("BodyVelocity")
                            bv.Name = "BodyVelocity"
                            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                            bv.Velocity = Vector3.zero
                            bv.Parent = root
                        end
                        if distance <= 10 then
                            AreaMob = true
                        end
                        if not AreaMob and Network(root) then
                            root.CFrame = CFrame.new(targetPos)
                        end
                        root.CanCollide = false
                        hum.WalkSpeed = 0
                        hum.JumpPower = 0
                    end
                end
            end
        end
        if Mon and Mon:FindFirstChild("HumanoidRootPart") then
            Mon.HumanoidRootPart.CanCollide = false
            Mon.Humanoid.WalkSpeed = 0
            Mon.Humanoid.JumpPower = 0
        end
    end)
end

Useskills = function(weapon, skill)
    if weapon == "Melee" then
        weaponSc("Melee")
        if skill == "Z" then vim1:SendKeyEvent(true, "Z", false, game); vim1:SendKeyEvent(false, "Z", false, game)
        elseif skill == "X" then vim1:SendKeyEvent(true, "X", false, game); vim1:SendKeyEvent(false, "X", false, game)
        elseif skill == "C" then vim1:SendKeyEvent(true, "C", false, game); vim1:SendKeyEvent(false, "C", false, game)
        end
    elseif weapon == "Sword" then
        weaponSc("Sword")
        if skill == "Z" then vim1:SendKeyEvent(true, "Z", false, game); vim1:SendKeyEvent(false, "Z", false, game)
        elseif skill == "X" then vim1:SendKeyEvent(true, "X", false, game); vim1:SendKeyEvent(false, "X", false, game)
        end
    elseif weapon == "Blox Fruit" then
        weaponSc("Blox Fruit")
        if skill == "Z" then vim1:SendKeyEvent(true, "Z", false, game); vim1:SendKeyEvent(false, "Z", false, game)
        elseif skill == "X" then vim1:SendKeyEvent(true, "X", false, game); vim1:SendKeyEvent(false, "X", false, game)
        elseif skill == "C" then vim1:SendKeyEvent(true, "C", false, game); vim1:SendKeyEvent(false, "C", false, game)
        elseif skill == "V" then vim1:SendKeyEvent(true, "V", false, game); vim1:SendKeyEvent(false, "V", false, game)
        end
    elseif weapon == "Gun" then
        weaponSc("Gun")
        if skill == "Z" then vim1:SendKeyEvent(true, "Z", false, game); vim1:SendKeyEvent(false, "Z", false, game)
        elseif skill == "X" then vim1:SendKeyEvent(true, "X", false, game); vim1:SendKeyEvent(false, "X", false, game)
        end
    end
    if weapon == "nil" and skill == "Y" then
        vim1:SendKeyEvent(true, "Y", false, game); vim1:SendKeyEvent(false, "Y", false, game)
    end
end

-- Namecall hook
local gg = getrawmetatable(game)
local old = gg.__namecall
setreadonly(gg, false)
gg.__namecall = newcclosure(function(...)
    local method = getnamecallmethod()
    local args = {...}
    if tostring(method) == "FireServer" then
        if tostring(args[1]) == "RemoteEvent" then
            if tostring(args[2]) ~= "true" and tostring(args[2]) ~= "false" then
                if (_G.FarmMastery_G and not SoulGuitar) or (_G.FarmMastery_Dev) or (_G.FarmBlazeEM) or (_G.Prehis_Skills) or (_G.SeaBeast1 or _G.FishBoat or _G.PGB or _G.Leviathan1 or _G.Complete_Trials) or (_G.AimMethod and ABmethod == "Aim Player") or (_G.AimMethod and ABmethod == "Nearest Aim") or _G.KaitunStandalone then
                    args[2] = MousePos
                    return old(unpack(args))
                end
            end
        end
    end
    return old(...)
end)

-- ============================================

-- MODULE 7: Utility Functions
-- ============================================

GetConnectionEnemies = function(a)
    for i,v in pairs(replicated:GetChildren()) do
        if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
    for i,v in next,game.Workspace.Enemies:GetChildren() do
        if v:IsA("Model") and ((typeof(a) == "table" and table.find(a, v.Name)) or v.Name == a) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            return v
        end
    end
end

LowCpu = function()
    local decalsyeeted = true
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    t.WaterWaveSize = 0; t.WaterWaveSpeed = 0; t.WaterReflectance = 0; t.WaterTransparency = 0
    l.GlobalShadows = false; l.FogEnd = 9e9; l.Brightness = 0
    settings().Rendering.QualityLevel = "Level01"
    for i, v in pairs(g:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then v.Material = "Plastic"; v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then v.BlastPressure = 1; v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then v.Enabled = false
        elseif v:IsA("MeshPart") then v.Material = "Plastic"; v.Reflectance = 0; v.TextureID = 10385902758728957
        end
    end
    for i, e in pairs(l:GetChildren()) do
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = false end
    end
end

CheckF = function()
    if GetBP("Dragon-Dragon") or GetBP("Gas-Gas") or GetBP("Yeti-Yeti") or GetBP("Kitsune-Kitsune") or GetBP("T-Rex-T-Rex") then return true end
end

CheckBoat = function()
    for i, v in pairs(workspace.Boats:GetChildren()) do
        if tostring(v.Owner.Value) == tostring(plr.Name) then return v end
    end
    return false
end

CheckEnemiesBoat = function()
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if (v.Name == "FishBoat") and v:FindFirstChild("Health").Value > 0 then return true end
    end
    return false
end

CheckPirateGrandBrigade = function()
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if (v.Name == "PirateGrandBrigade" or v.Name == "PirateBrigade") and v:FindFirstChild("Health").Value > 0 then return true end
    end
    return false
end

CheckShark = function()
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == "Shark" and Attack.Alive(v) then return true end
    end
    return false
end

CheckTerrorShark = function()
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == "Terrorshark" and Attack.Alive(v) then return true end
    end
    return false
end

CheckPiranha = function()
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == "Piranha" and Attack.Alive(v) then return true end
    end
    return false
end

CheckFishCrew = function()
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if (v.Name == "Fish Crew Member" or v.Name == "Haunted Crew Member") and Attack.Alive(v) then return true end
    end
    return false
end

CheckHauntedCrew = function()
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if (v.Name == "Haunted Crew Member") and Attack.Alive(v) then return true end
    end
    return false
end

CheckSeaBeast = function()
    if workspace.SeaBeasts:FindFirstChild("SeaBeast1") then return true end
    return false
end

CheckLeviathan = function()
    if workspace.SeaBeasts:FindFirstChild("Leviathan") then return true end
    return false
end

UpdStFruit = function()
    for z,x in next, plr.Backpack:GetChildren() do
        StoreFruit = x:FindFirstChild("EatRemote", true)
        if StoreFruit then
            replicated.Remotes.CommF_:InvokeServer("StoreFruit", StoreFruit.Parent:GetAttribute("OriginalName"), plr.Backpack:FindFirstChild(x.Name))
        end
    end
end

collectFruits = function(Succes)
    if Succes then
        local Character = plr.Character
        for _,v1 in pairs(workspace:GetChildren()) do
            if string.find(v1.Name, "Fruit") then v1.Handle.CFrame = Character.HumanoidRootPart.CFrame end
        end
    end
end

Getmoon = function()
    if World1 then return Lighting.FantasySky.MoonTextureId
    elseif World2 then return Lighting.FantasySky.MoonTextureId
    elseif World3 then return Lighting.Sky.MoonTextureId
    end
end

DropFruits = function()
    for _,v3 in next, plr.Backpack:GetChildren() do
        if string.find(v3.Name, "Fruit") then
            EquipWeapon(v3.Name) wait(.1)
            if plr.PlayerGui.Main.Dialogue.Visible == true then plr.PlayerGui.Main.Dialogue.Visible = false end
            EquipWeapon(v3.Name) plr.Character:FindFirstChild(v3.Name).EatRemote:InvokeServer("Drop")
        end
    end
    for a,b2 in pairs(plr.Character:GetChildren()) do
        if string.find(b2.Name, "Fruit") then
            EquipWeapon(b2.Name) wait(.1)
            if plr.PlayerGui.Main.Dialogue.Visible == true then plr.PlayerGui.Main.Dialogue.Visible = false end
            EquipWeapon(b2.Name) plr.Character:FindFirstChild(b2.Name).EatRemote:InvokeServer("Drop")
        end
    end
end

GetBP = function(v)
    return plr.Backpack:FindFirstChild(v) or plr.Character:FindFirstChild(v)
end

GetIn = function(Name)
    for _ ,v1 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
        if type(v1) == "table" then
            if v1.Name == Name or plr.Character:FindFirstChild(Name) or plr.Backpack:FindFirstChild(Name) then return true end
        end
    end
    return false
end

GetM = function(Name)
    for _,tab in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
        if type(tab) == "table" then
            if tab.Type == "Material" then
                if tab.Name == Name then return tab.Count end
            end
        end
    end
    return 0
end

GetWP = function(nametool)
    for _,v4 in pairs(replicated.Remotes.CommF_:InvokeServer("getInventory")) do
        if type(v4) == "table" then
            if v4.Type == "Sword" then
                if v4.Name == nametool or plr.Character:FindFirstChild(nametool) or plr.Backpack:FindFirstChild(nametool) then return true end
            end
        end
    end
    return false
end

getInfinity_Ability = function(Method, Var)
    if not Root then return end
    if Method == "Soru" and Var then
        for _,gc in next, getgc() do
            if plr.Character.Soru then
                if ((typeof(gc) == "function") and (getfenv(gc).script == plr.Character.Soru)) then
                    for _, v in next, getupvalues(gc) do
                        if (typeof(v) == "table") then
                            repeat wait(Sec) v.LastUse = 0 until not Var or (plr.Character.Humanoid.Health <= 0)
                        end
                    end
                end
            end
        end
    elseif Method == "Energy" and Var then
        plr.Character.Energy.Changed:connect(function()
            if Var then plr.Character.Energy.Value = Energy end
        end)
    elseif Method == "Observation" and Var then
        local VisionRadius = plr.VisionRadius
        VisionRadius.Value = math.huge
    end
end

Hop = function()
    pcall(function()
        for count = math.random(1, math.random(40, 75)), 100 do
            local remote = replicated.__ServerBrowser:InvokeServer(count)
            for _, v in next, remote do
                if tonumber(v['Count']) < 12 then TeleportService:TeleportToPlaceInstance(game.PlaceId, _) end
            end
        end
    end)
end

-- ============================================

-- MODULE 8: Movement & Tween System
-- ============================================

local block = Instance.new("Part", workspace)
block.Size = Vector3.new(1, 1, 1)
block.Name = "Rip_Indra"
block.Anchored = true
block.CanCollide = false
block.CanTouch = false
block.Transparency = 1
local blockfind = workspace:FindFirstChild(block.Name)
if blockfind and blockfind ~= block then blockfind:Destroy() end

task.spawn(function()while task.wait()do if block and block.Parent==workspace then if shouldTween then getgenv().OnFarm=true else getgenv().OnFarm=false end else getgenv().OnFarm=false end end end)
task.spawn(function()local a=game.Players.LocalPlayer;repeat task.wait()until a.Character and a.Character.PrimaryPart;block.CFrame=a.Character.PrimaryPart.CFrame;while task.wait()do pcall(function()if getgenv().OnFarm then if block and block.Parent==workspace then local b=a.Character and a.Character.PrimaryPart;if b and(b.Position-block.Position).Magnitude<=200 then b.CFrame=block.CFrame else block.CFrame=b.CFrame end end;local c=a.Character;if c then for d,e in pairs(c:GetChildren())do if e:IsA("BasePart")then e.CanCollide=false end end end else local c=a.Character;if c then for d,e in pairs(c:GetChildren())do if e:IsA("BasePart")then e.CanCollide=true end end end end end)end end)

local Settings = {
    ["Tween Speed"] = 350,
    ["Bypass Teleport"] = true,
    ["Up Y"] = false,
    ["Up Y When Low Health"] = false,
    ["Same Y"] = false
}

local newdao = CFrame.new(10641.0918, -1953.92981, 9825.07031, -0.652825892, -9.2805891e-08, -0.757508039, -2.73638356e-08, 1, -9.89323823e-08, 0.757508039, -4.38572947e-08, -0.652825892)
local cframenpc = CFrame.new(-16271.126, 25.5847301, 1371.98755, 0.999396622, -5.78875188e-08, -0.0347310975, 5.52972779e-08, 1, -8.7544322e-08, 0.034731105, 8.28877091e-08, 0.999396741)

function Convert_CFrame(x)
    if not x then return end
    if typeof(x) == "Vector3" then return CFrame.new(x)
    elseif typeof(x) == "CFrame" then return x
    elseif typeof(x) == "Model" then return x:GetPivot()
    elseif x.CFrame then return x.CFrame
    end
    return nil
end

function GetDistance(POS_1, POS_2, NO_Y)
    if POS_1 == nil then return 9e9 end
    local Character = LocalPlayer.Character
    if not Character then return 9e9 end
    local Humanoid = Character:FindFirstChild("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then return 9e9 end
    if POS_2 == nil then
        POS_2 = Character:FindFirstChild("HumanoidRootPart")
        if not POS_2 then return 9e9 end
    end
    local pos1 = Convert_CFrame(POS_1)
    local pos2 = Convert_CFrame(POS_2)
    if NO_Y then
        return (Vector3.new(pos1.X, 0, pos1.Z) - Vector3.new(pos2.X, 0, pos2.Z)).Magnitude
    else
        return (pos1.Position - pos2.Position).Magnitude
    end
end

function InArea(POS)
    local WorldOrigin = workspace:FindFirstChild("_WorldOrigin")
    if not WorldOrigin then return {Name = ""} end
    local pos = Convert_CFrame(POS)
    for i,v in next, WorldOrigin.Locations:GetChildren() do
        if v:FindFirstChild("Mesh") and (pos.Position - v.Position).Magnitude <= v.Mesh.Scale.X then
            return v
        end
    end
    return {Name = ""}
end

function GetSpawnPoint(x)
    local Spawns = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("PlayerSpawns") and workspace._WorldOrigin.PlayerSpawns:FindFirstChild("Pirates")
    if not Spawns then return end
    for i,v in next, Spawns:GetChildren() do
        if v:FindFirstChild("Part") and (v.Part.Position - x.Position).Magnitude <= 2500 then return v end
    end
end

function CheckLegendaryItems()
    local function CheckItem(ITEM_NAME)
        for i,v in next, LocalPlayer.Backpack:GetChildren() do
            if v:IsA('Tool') and (v.Name == ITEM_NAME or string.find(v.Name, ITEM_NAME)) then return v end
        end
        for i,v in next, LocalPlayer.Character:GetChildren() do
            if v:IsA('Tool') and (v.Name == ITEM_NAME or string.find(v.Name, ITEM_NAME)) then return v end
        end
    end
    if CheckItem("God's Chalice") or CheckItem("Fist of Darkness") or CheckItem("Sweet Chalice") or CheckItem("Hallow Essence") or CheckItem("Flower1") then return true end
    return false
end

function WaitForHumanoid()
    local Character = LocalPlayer.Character
    if not Character then return nil end
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid then return Humanoid end
    local timeout = tick() + 5
    while tick() < timeout do
        Humanoid = Character:FindFirstChild("Humanoid")
        if Humanoid then return Humanoid end
        task.wait(0.1)
    end
    return nil
end

function checkinventory(v)
    if v then
        for i, vl in pairs(ReplicatedStorage.Remotes.CommF_:InvokeServer("getInventory")) do
            if vl.Name == v then return true end
        end
    end
    return false
end

function getdis(a,b)
    b = b or LocalPlayer.Character.HumanoidRootPart.CFrame
    local _a = CFrame.new(a.X, b.Y, a.Z)
    local _b = CFrame.new(b.X,b.Y,b.Z)
    return (_a.Position - _b.Position).Magnitude
end

function CanBypassTeleport(x)
    local AreaName = InArea(x).Name
    if AreaName == "" then return false end
    if not Settings["Bypass Teleport"] or AreaName:find("Dimension") or AreaName:find("Submerged") or AreaName == "Sealed Cavern" or AreaName:lower():find("under") or CheckLegendaryItems() then return false end
    if LocalPlayer.Data and LocalPlayer.Data.LastSpawnPoint and LocalPlayer.Data.LastSpawnPoint.Value == "SubmergedIsland" then return false end
    if GetDistance(x.Position) <= 3500 then return false end
    return true
end

function GetBypassCFrame(x)
    local Max = math.huge
    local Pos
    local Spawns = workspace._WorldOrigin.PlayerSpawns.Pirates:GetChildren()
    local HRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not HRP then return nil end
    for i,v in next, Spawns do
        if v:FindFirstChild("Part") then
            if (x.Position - HRP.Position).Magnitude >= 3000 and GetSpawnPoint(v.Part) ~= GetSpawnPoint(HRP) and (v.Part.Position - HRP.Position).Magnitude <= 10000 and (v.Part.Position - x.Position).Magnitude <= Max then
                Max = (v.Part.Position - x.Position).Magnitude
                Pos = v
            end
        end
    end
    return Pos
end

function BypassTP(Target)
    local Character = LocalPlayer.Character
    if not Character then return end
    local Humanoid = WaitForHumanoid()
    if not Humanoid or Humanoid.Health <= 0 then return end
    if CanBypassTeleport(Target) and GetBypassCFrame(Target) then
        local TargetTP = GetBypassCFrame(Target)
        if TargetTP and TargetTP:FindFirstChild("Part") then
            Character.LastSpawnPoint.Disabled = true
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetLastSpawnPoint", TargetTP.Name)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("SetSpawnPoint")
            Character:PivotTo(TargetTP.Part.CFrame)
            Humanoid:ChangeState(15)
            repeat task.wait() until LocalPlayer.Character and WaitForHumanoid() and WaitForHumanoid().Health > 0
        end
    end
end

function totopofgreattree()
    if getdis(CFrame.new(28310.0234, 14895.1123, 109.456741)) > 1500 then
        ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(28310.0234, 14895.1123, 109.456741))
        wait(0.3)
    end
    local targetCF = CFrame.new(28607.5352, 14896.5449, 106.011726)
    _tp(targetCF)
    repeat wait() until getdis(targetCF) <= 5
    wait(0.5)
    for i = 1, 4 do
        ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "TeleportBack")
    end
end

function requestentrance(pos)
    local tb = {}
    local targetPos = pos
    if typeof(pos) == "CFrame" then targetPos = pos.Position end
    if sea1 then
        tb = {["Sky3"] = Vector3.new(-7894, 5547, -380),["Sky3Exit"] = Vector3.new(-4607, 874, -1667),["UnderWater"] = Vector3.new(61163, 11, 1819),["Underwater City"] = Vector3.new(61165.19140625, 0.18704631924629211, 1897.379150390625),["Pirate Village"] = Vector3.new(-1242.4625244140625, 4.787059783935547, 3901.282958984375),["UnderwaterExit"] = Vector3.new(4050, -1, -1814)}
    elseif sea2 then
        tb = {["Swan Mansion"] = Vector3.new(-390, 332, 673),["Swan Room"] = Vector3.new(2285, 15, 905),["Cursed Ship"] = Vector3.new(923, 126, 32852),["Zombie Island"] = Vector3.new(-6509, 83, -133)}
    else
        tb = {["Hydra Island"] = Vector3.new(5657.88623046875, 1013.0790405273438, -335.4996337890625),["Mansion"] = Vector3.new(-12462, 375, -7552),["Castle"] = Vector3.new(-5036, 315, -3179),["Temple of Time"] = Vector3.new(28286, 14897, 103),["Greate Tree"] = Vector3.new(3024.1709, 2280.69434, -7325.12793)}
        if not checkinventory("Valkyrie Helm") then return end
    end
    local x, y = nil, math.huge
    for i, v in pairs(tb) do
        local distance = (typeof(v) == "Vector3" and (v - targetPos).Magnitude) or (v.Position - targetPos).Magnitude
        if distance < y then y = distance; x = v end
    end
    if x and y and y < getdis(pos) then
        pcall(function() if _G.TweenCache then _G.TweenCache:Cancel() end end)
        if typeof(x) == "Vector3" and x.X == 3024.1709 and x.Y == 2280.69434 and x.Z == -7325.12793 and ReplicatedStorage.Remotes.CommF_:InvokeServer("RaceV4Progress", "Check") >= 2 then
            totopofgreattree(); wait(1)
        elseif y < getdis(pos) then
            local requestPos = typeof(x) == "Vector3" and x or x.Position
            ReplicatedStorage.Remotes.CommF_:InvokeServer("requestEntrance", requestPos); wait(1)
        end
    end
end

_tp = function(target)
    local gg
    if typeof(target) == "Vector3" then gg = CFrame.new(target)
    elseif typeof(target) == "CFrame" then gg = target
    else gg = target and target.CFrame
    end
    if not gg then return end
    local character = plr.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart
    pcall(function() if CanBypassTeleport(gg) then BypassTP(gg); task.wait(0.5) end end)
    pcall(function() requestentrance(target) end)
    if sea3 and getdis(gg.Position, newdao.Position) < 2000 then
        local hrp = plr.Character.HumanoidRootPart
        if math.abs(newdao.Position.Y - hrp.CFrame.Y) > 1000 then
            repeat
                task.wait()
                old_tp(cframenpc)
                if getdis(cframenpc) < 10 then
                    local net = ReplicatedStorage.Modules.Net
                    net["RF/SubmarineWorkerSpeak"]:InvokeServer("AskKilledTikiBoss"); task.wait(0.5)
                    net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
                end
            until getdis(gg.Position) < 2000
            task.wait(0.6)
            pcall(function() if hrp:FindFirstChild("BodyClip") then hrp.BodyClip:Destroy() end end)
        end
    end
    local distance = (gg.Position - rootPart.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / 300, Enum.EasingStyle.Linear)
    local tween = game:GetService("TweenService"):Create(block, tweenInfo, {CFrame = gg})
    if plr.Character.Humanoid.Sit == true then block.CFrame = CFrame.new(block.Position.X, gg.Y, block.Position.Z) end
    tween:Play()
    task.spawn(function()
        while tween.PlaybackState == Enum.PlaybackState.Playing do
            if not shouldTween then tween:Cancel(); break end
            task.wait(0.1)
        end
    end)
    return tween
end

old_tp = function(p)
    local char = plr.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = p
    end
end

TeleportToTarget = function(targetCFrame)
    if (targetCFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude > 1000 then _tp(targetCFrame) else _tp(targetCFrame) end
end

notween = function(p) plr.Character.HumanoidRootPart.CFrame = p end

function BTP(p)
    local player = game.Players.LocalPlayer
    local humanoidRootPart = player.Character.HumanoidRootPart
    local humanoid = player.Character.Humanoid
    local playerGui = player.PlayerGui.Main
    local targetPosition = p.Position
    local lastPosition = humanoidRootPart.Position
    repeat
        humanoid.Health = 0
        humanoidRootPart.CFrame = p
        playerGui.Quest.Visible = false
        if (humanoidRootPart.Position - lastPosition).Magnitude > 1 then
            lastPosition = humanoidRootPart.Position
            humanoidRootPart.CFrame = p
        end
        task.wait(0.5)
    until (p.Position - humanoidRootPart.Position).Magnitude <= 2000
end

-- Main farm loop
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.SailBoat_Hydra or _G.WardenBoss or _G.AutoFactory or _G.HighestMirage or _G.HCM or _G.PGB or _G.Leviathan1 or _G.UPGDrago or _G.Complete_Trials or _G.TpDrago_Prehis or _G.BuyDrago or _G.AutoFireFlowers or _G.DT_Uzoth or _G.AutoBerry or _G.Prefully or _G.Prehis_Find or _G.Prehis_Skills or _G.Prehis_DB or _G.Prehis_DE or _G.FarmBlazeEM or _G.Dojoo or _G.CollectPresent or _G.AutoLawKak or _G.TpLab or _G.AutoPhoenixF or _G.AutoFarmChest or _G.AutoHytHallow or _G.LongsWord or _G.BlackSpikey or _G.AutoHolyTorch or _G.TrainDrago or _G.AutoSaber or _G.FarmMastery_Dev or _G.CitizenQuest or _G.AutoEctoplasm or _G.KeysRen or _G.Auto_Rainbow_Haki or _G.obsFarm or _G.AutoBigmom or _G.Doughv2 or _G.AuraBoss or _G.Raiding or _G.Auto_Cavender or _G.TpPly or _G.Bartilo_Quest or _G.Level or _G.FarmEliteHunt or _G.AutoZou or _G.AutoFarm_Bone or getgenv().AutoMaterial or _G.CraftVM or _G.FrozenTP or _G.TPDoor or _G.AcientOne or _G.AutoFarmNear or _G.AutoRaidCastle or _G.DarkBladev3 or _G.AutoFarmRaid or _G.Auto_Cake_Prince or _G.Addealer or _G.TPNpc or _G.TwinHook or _G.FindMirage or _G.FarmChestM or _G.Shark or _G.TerrorShark or _G.Piranha or _G.MobCrew or _G.SeaBeast1 or _G.FishBoat or _G.AutoPole or _G.AutoPoleV2 or _G.Auto_SuperHuman or _G.AutoDeathStep or _G.Auto_SharkMan_Karate or _G.Auto_Electric_Claw or _G.AutoDragonTalon or _G.Auto_Def_DarkCoat or _G.Auto_God_Human or _G.Auto_Tushita or _G.AutoMatSoul or _G.AutoKenVTWO or _G.AutoSerpentBow or _G.AutoFMon or _G.Auto_Soul_Guitar or _G.TPGEAR or _G.AutoSaw or _G.AutoTridentW2 or _G.AutoEvoRace or _G.AutoGetQuestBounty or _G.MarinesCoat or _G.TravelDres or _G.Defeating or _G.DummyMan or _G.Auto_Yama or _G.Auto_SwanGG or _G.SwanCoat or _G.AutoEcBoss or _G.Auto_Mink or _G.Auto_Human or _G.Auto_Skypiea or _G.Auto_Fish or _G.CDK_TS or _G.CDK_YM or _G.CDK or _G.AutoFarmGodChalice or _G.AutoFistDarkness or _G.AutoMiror or _G.Teleport or _G.AutoKilo or _G.AutoGetUsoap or _G.Praying or _G.TryLucky or _G.AutoColShad then
                shouldTween = true
                if not plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then
                    local Noclip = Instance.new("BodyVelocity")
                    Noclip.Name = "BodyClip"
                    Noclip.Parent = plr.Character.HumanoidRootPart
                    Noclip.MaxForce = Vector3.new(100000,100000,100000)
                    Noclip.Velocity = Vector3.new(0,0,0)
                end
                if not plr.Character:FindFirstChild("highlight") then
                    local Test = Instance.new("Highlight")
                    Test.Name = "highlight"
                    Test.Enabled = true
                    Test.FillColor = Color3.fromRGB(0,255,254)
                    Test.OutlineColor = Color3.fromRGB(0,255,254)
                    Test.FillTransparency = 0.5
                    Test.OutlineTransparency = 0.2
                    Test.Parent = plr.Character
                end
                for _, no in pairs(plr.Character:GetDescendants()) do if no:IsA("BasePart") then no.CanCollide = false end end
            else
                shouldTween = false
                if plr.Character.HumanoidRootPart:FindFirstChild("BodyClip") then plr.Character.HumanoidRootPart:FindFirstChild("BodyClip"):Destroy() end
                if plr.Character:FindFirstChild('highlight') then plr.Character:FindFirstChild('highlight'):Destroy() end
            end
        end)
    end
end)

-- ============================================

-- MODULE 9: Quest System
-- ============================================

QuestB = function()
    if World1 then
        if _G.FindBoss == "The Gorilla King" then bMon = "The Gorilla King"; Qname = "JungleQuest"; Qdata = 3; PosQBoss = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102); PosB = CFrame.new(-1088.75977, 8.13463783, -488.559906, -0.707134247, 0, 0.707079291, 0, 1, 0, -0.707079291, 0, -0.707134247)
        elseif _G.FindBoss == "Bobby" then bMon = "Bobby"; Qname = "BuggyQuest1"; Qdata = 3; PosQBoss = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188); PosB = CFrame.new(-1087.3760986328, 46.949409484863, 4040.1462402344)
        elseif _G.FindBoss == "The Saw" then bMon = "The Saw"; PosB = CFrame.new(-784.89715576172, 72.427383422852, 1603.5822753906)
        elseif _G.FindBoss == "Yeti" then bMon = "Yeti"; Qname = "SnowQuest"; Qdata = 3; PosQBoss = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156); PosB = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172)
        elseif _G.FindBoss == "Mob Leader" then bMon = "Mob Leader"; PosB = CFrame.new(-2844.7307128906, 7.4180502891541, 5356.6723632813)
        elseif _G.FindBoss == "Vice Admiral" then bMon = "Vice Admiral"; Qname = "MarineQuest2"; Qdata = 2; PosQBoss = CFrame.new(-5036.2465820313, 28.677835464478, 4324.56640625); PosB = CFrame.new(-5006.5454101563, 88.032081604004, 4353.162109375)
        elseif _G.FindBoss == "Saber Expert" then bMon = "Saber Expert"; PosB = CFrame.new(-1458.89502, 29.8870335, -50.633564)
        elseif _G.FindBoss == "Warden" then bMon = "Warden"; Qname = "ImpelQuest"; Qdata = 1; PosB = CFrame.new(5278.04932, 2.15167475, 944.101929, 0.220546961, -4.49946401e-06, 0.975376427, -1.95412576e-05, 1, 9.03162072e-06, -0.975376427, -2.10519756e-05, 0.220546961); PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
        elseif _G.FindBoss == "Chief Warden" then bMon = "Chief Warden"; Qname = "ImpelQuest"; Qdata = 2; PosB = CFrame.new(5206.92578, 0.997753382, 814.976746, 0.342041343, -0.00062915677, 0.939684749, 0.00191645394, 0.999998152, -2.80422337e-05, -0.939682961, 0.00181045406, 0.342041939); PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
        elseif _G.FindBoss == "Swan" then bMon = "Swan"; Qname = "ImpelQuest"; Qdata = 3; PosB = CFrame.new(5325.09619, 7.03906584, 719.570679, -0.309060812, 0, 0.951042235, 0, 1, 0, -0.951042235, 0, -0.309060812); PosQBoss = CFrame.new(5191.86133, 2.84020686, 686.438721, -0.731384635, 0, 0.681965172, 0, 1, 0, -0.681965172, 0, -0.731384635)
        elseif _G.FindBoss == "Magma Admiral" then bMon = "Magma Admiral"; Qname = "MagmaQuest"; Qdata = 3; PosQBoss = CFrame.new(-5314.6220703125, 12.262420654297, 8517.279296875); PosB = CFrame.new(-5765.8969726563, 82.92064666748, 8718.3046875)
        elseif _G.FindBoss == "Fishman Lord" then bMon = "Fishman Lord"; Qname = "FishmanQuest"; Qdata = 3; PosQBoss = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734); PosB = CFrame.new(61260.15234375, 30.950881958008, 1193.4329833984)
        elseif _G.FindBoss == "Wysper" then bMon = "Wysper"; Qname = "SkyExp1Quest"; Qdata = 3; PosQBoss = CFrame.new(-7861.947265625, 5545.517578125, -379.85974121094); PosB = CFrame.new(-7866.1333007813, 5576.4311523438, -546.74816894531)
        elseif _G.FindBoss == "Thunder God" then bMon = "Thunder God"; Qname = "SkyExp2Quest"; Qdata = 3; PosQBoss = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125); PosB = CFrame.new(-7994.984375, 5761.025390625, -2088.6479492188)
        elseif _G.FindBoss == "Cyborg" then bMon = "Cyborg"; Qname = "FountainQuest"; Qdata = 3; PosQBoss = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875); PosB = CFrame.new(6094.0249023438, 73.770050048828, 3825.7348632813)
        elseif _G.FindBoss == "Ice Admiral" then bMon = "Ice Admiral"; Qdata = nil; PosQBoss = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219); PosB = CFrame.new(1266.08948, 26.1757946, -1399.57678, -0.573599219, 0, -0.81913656, 0, 1, 0, 0.81913656, 0, -0.573599219)
        elseif _G.FindBoss == "Greybeard" then bMon = "Greybeard"; Qdata = nil; PosQBoss = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188); PosB = CFrame.new(-5081.3452148438, 85.221641540527, 4257.3588867188)
        end
    end
    if World2 then
        if _G.FindBoss == "Diamond" then bMon = "Diamond"; Qname = "Area1Quest"; Qdata = 3; PosQBoss = CFrame.new(-427.5666809082, 73.313781738281, 1835.4208984375); PosB = CFrame.new(-1576.7166748047, 198.59265136719, 13.724286079407)
        elseif _G.FindBoss == "Jeremy" then bMon = "Jeremy"; Qname = "Area2Quest"; Qdata = 3; PosQBoss = CFrame.new(636.79943847656, 73.413787841797, 918.00415039063); PosB = CFrame.new(2006.9261474609, 448.95666503906, 853.98284912109)
        elseif _G.FindBoss == "Orbitus" then bMon = "Orbitus"; Qname = "MarineQuest3"; Qdata = 3; PosQBoss = CFrame.new(-2441.986328125, 73.359344482422, -3217.5324707031); PosB = CFrame.new(-2172.7399902344, 103.32216644287, -4015.025390625)
        elseif _G.FindBoss == "Don Swan" then bMon = "Don Swan"; PosB = CFrame.new(2286.2004394531, 15.177839279175, 863.8388671875)
        elseif _G.FindBoss == "Smoke Admiral" then bMon = "Smoke Admiral"; Qname = "IceSideQuest"; Qdata = 3; PosQBoss = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813); PosB = CFrame.new(-5275.1987304688, 20.757257461548, -5260.6669921875)
        elseif _G.FindBoss == "Awakened Ice Admiral" then bMon = "Awakened Ice Admiral"; Qname = "FrostQuest"; Qdata = 3; PosQBoss = CFrame.new(5668.9780273438, 28.519989013672, -6483.3520507813); PosB = CFrame.new(6403.5439453125, 340.29766845703, -6894.5595703125)
        elseif _G.FindBoss == "Tide Keeper" then bMon = "Tide Keeper"; Qname = "ForgottenQuest"; Qdata = 3; PosQBoss = CFrame.new(-3053.9814453125, 237.18954467773, -10145.0390625); PosB = CFrame.new(-3795.6423339844, 105.88877105713, -11421.307617188)
        elseif _G.FindBoss == "Darkbeard" then bMon = "Darkbeard"; Qdata = nil; PosQBoss = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531); PosB = CFrame.new(3677.08203125, 62.751937866211, -3144.8332519531)
        elseif _G.FindBoss == "Cursed Captain" then bMon = "Cursed Captain"; Qdata = nil; PosQBoss = CFrame.new(916.928589, 181.092773, 33422); PosB = CFrame.new(916.928589, 181.092773, 33422)
        elseif _G.FindBoss == "Order" then bMon = "Order"; Qdata = nil; PosQBoss = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875); PosB = CFrame.new(-6217.2021484375, 28.047645568848, -5053.1357421875)
        end
    end
    if World3 then
        if _G.FindBoss == "Stone" then bMon = "Stone"; Qname = "PiratePortQuest"; Qdata = 3; PosQBoss = CFrame.new(-289.76705932617, 43.819011688232, 5579.9384765625); PosB = CFrame.new(-1027.6512451172, 92.404174804688, 6578.8530273438)
        elseif _G.FindBoss == "Hydra Leader" then bMon = "Hydra Leader"; Qname = "VenomCrewQuest"; Qdata = 3; PosQBoss = CFrame.new(5211.021484375, 1004.35778859375, 758.1847534179688); PosB = CFrame.new(5821.89794921875, 1019.0950927734375, -73.71923065185547)
        elseif _G.FindBoss == "Kilo Admiral" then bMon = "Kilo Admiral"; Qname = "MarineTreeIsland"; Qdata = 3; PosQBoss = CFrame.new(2179.3010253906, 28.731239318848, -6739.9741210938); PosB = CFrame.new(2764.2233886719, 432.46154785156, -7144.4580078125)
        elseif _G.FindBoss == "Captain Elephant" then bMon = "Captain Elephant"; Qname = "DeepForestIsland"; Qdata = 3; PosQBoss = CFrame.new(-13232.682617188, 332.40396118164, -7626.01171875); PosB = CFrame.new(-13376.7578125, 433.28689575195, -8071.392578125)
        elseif _G.FindBoss == "Beautiful Pirate" then bMon = "Beautiful Pirate"; Qname = "DeepForestIsland2"; Qdata = 3; PosQBoss = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375); PosB = CFrame.new(5283.609375, 22.56223487854, -110.78285217285)
        elseif _G.FindBoss == "Cake Queen" then bMon = "Cake Queen"; Qname = "IceCreamIslandQuest"; Qdata = 3; PosQBoss = CFrame.new(-819.376709, 64.9259796, -10967.2832, -0.766061664, 0, 0.642767608, 0, 1, 0, -0.642767608, 0, -0.766061664); PosB = CFrame.new(-678.648804, 381.353943, -11114.2012, -0.908641815, 0.00149294338, 0.41757378, 0.00837114919, 0.999857843, 0.0146408929, -0.417492568, 0.0167988986, -0.90852499)
        elseif _G.FindBoss == "Dough King" then bMon = "Dough King"; Qname = "IceCreamIslandQuest"
        elseif _G.FindBoss == "Longma" then bMon = "Longma"; Qdata = nil; PosQBoss = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125); PosB = CFrame.new(-10238.875976563, 389.7912902832, -9549.7939453125)
        elseif _G.FindBoss == "Soul Reaper" then bMon = "Soul Reaper"; Qdata = nil; PosQBoss = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813); PosB = CFrame.new(-9524.7890625, 315.80429077148, 6655.7192382813)
        end
    end
end

QuestBeta = function()
    local Neta = QuestB()
    return {[0] = _G.FindBoss, [1] = bMon, [2] = Qdata, [3] = Qname, [4] = PosB, [5] = PosQBoss}
end

local Quests = require(game:GetService("ReplicatedStorage"):WaitForChild("Quests"))
local GuideModule = require(game:GetService("ReplicatedStorage"):WaitForChild("GuideModule"))

local blacklistquest = {"MarineQuest","BartiloQuest","CitizenQuest","Trainees"}

CheckSea = function(b)
    if (game.PlaceId == 2753915549 or game.PlaceId == 85211729168715) and b == 1 then return true
    elseif (game.PlaceId == 4442272183 or game.PlaceId == 79091703265657) and b == 2 then return true
    elseif (game.PlaceId == 7449423635 or game.PlaceId == 100117331123089) and b == 3 then return true
    end
    return false
end

GetQuestPointFromNPC = function(npcName)
    for _, npc in pairs(workspace.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then return npc.HumanoidRootPart.CFrame end
    end
    for _, npc in pairs(replicated.NPCs:GetChildren()) do
        if npc.Name == npcName and npc:FindFirstChild("HumanoidRootPart") then return npc.HumanoidRootPart.CFrame end
    end
    return nil
end

GetQuests = function()
    local lvl = plr.Data.Level.Value
    local LevelReq = 0
    local mmb = {}
    if lvl >= 700 and CheckSea(1) then
        mmb["Mob"] = "Galley Captain"; mmb["NameQuest"] = "FountainQuest"; mmb["ID"] = 2; mmb["LevelReq"] = 700
    elseif lvl >= 1500 and CheckSea(2) then
        mmb["Mob"] = "Water Fighter"; mmb["NameQuest"] = "ForgottenQuest"; mmb["ID"] = 2; mmb["LevelReq"] = 1450
    else
        for r, v in pairs(Quests) do
            for id, v1 in pairs(v) do
                local LvReq = v1.LevelReq
                for nguoi, tinh in pairs(v1.Task) do
                    if lvl >= LvReq and LevelReq <= LvReq and v1.Task[nguoi] > 1 and not table.find(blacklistquest, r) then
                        LevelReq = LvReq
                        mmb["Mob"] = nguoi
                        mmb["NameQuest"] = r
                        mmb["ID"] = id
                        mmb["LevelReq"] = LvReq
                    end
                end
            end
        end
    end
    return mmb
end

GetQuestPoint = function()
    if GuideModule and GuideModule.Data and GuideModule.Data.LastClosestNPC then
        return GetQuestPointFromNPC(GuideModule.Data.LastClosestNPC)
    end
    return nil
end

MaterialMon = function()
    local a=game.Players.LocalPlayer;local b=a.Character and a.Character:FindFirstChild("HumanoidRootPart")if not b then return end;shouldRequestEntrance=function(c,d)local e=(b.Position-c).Magnitude;if e>=d then replicated.Remotes.CommF_:InvokeServer("requestEntrance",c)end end
    if World1 then
        if SelectMaterial=="Angel Wings"then MMon={"Shanda","Royal Squad","Royal Soldier","Wysper","Thunder God"}MPos=CFrame.new(-4698,845,-1912)SP="Default"local c=Vector3.new(-4607.82275,872.54248,-1667.55688)shouldRequestEntrance(c,10000)
        elseif SelectMaterial=="Leather + Scrap Metal"then MMon={"Brute","Pirate"}MPos=CFrame.new(-1145,15,4350)SP="Default"
        elseif SelectMaterial=="Magma Ore"then MMon={"Military Soldier","Military Spy","Magma Admiral"}MPos=CFrame.new(-5815,84,8820)SP="Default"
        elseif SelectMaterial=="Fish Tail"then MMon={"Fishman Warrior","Fishman Commando","Fishman Lord"}MPos=CFrame.new(61123,19,1569)SP="Default"local c=Vector3.new(61163.8515625,5.342342376708984,1819.7841796875)shouldRequestEntrance(c,17000)
        end
    elseif World2 then
        if SelectMaterial=="Leather + Scrap Metal"then MMon={"Marine Captain"}MPos=CFrame.new(-2010.5059814453125,73.00115966796875,-3326.620849609375)SP="Default"
        elseif SelectMaterial=="Magma Ore"then MMon={"Magma Ninja","Lava Pirate"}MPos=CFrame.new(-5428,78,-5959)SP="Default"
        elseif SelectMaterial=="Ectoplasm"then MMon={"Ship Deckhand","Ship Engineer","Ship Steward","Ship Officer"}MPos=CFrame.new(911.35827636719,125.95812988281,33159.5390625)SP="Default"local c=Vector3.new(61163.8515625,5.342342376708984,1819.7841796875)shouldRequestEntrance(c,18000)
        elseif SelectMaterial=="Mystic Droplet"then MMon={"Water Fighter"}MPos=CFrame.new(-3385,239,-10542)SP="Default"
        elseif SelectMaterial=="Radioactive Material"then MMon={"Factory Staff"}MPos=CFrame.new(295,73,-56)SP="Default"
        elseif SelectMaterial=="Vampire Fang"then MMon={"Vampire"}MPos=CFrame.new(-6033,7,-1317)SP="Default"
        end
    elseif World3 then
        if SelectMaterial=="Scrap Metal"then MMon={"Pirate Millionaire","Pistol Billionaire"}MPos=CFrame.new(-712,98,5711)SP="Default"
        elseif SelectMaterial=="Demonic Wisp"then MMon={"Demonic Soul"}MPos=CFrame.new(-9515,142,5536)SP="Default"
        elseif SelectMaterial=="Conjured Cocoa"then MMon={"Cocoa Warrior","Chocolate Bar Battler"}MPos=CFrame.new(95,73,-12309)SP="Default"
        elseif SelectMaterial=="Dragon Scale"then MMon={"Dragon Crew Warrior","Dragon Crew Archer"}MPos=CFrame.new(7021,55,-730)SP="Default"
        elseif SelectMaterial=="Gunpowder"then MMon={"Pirate Millionaire"}MPos=CFrame.new(-712,98,5711)SP="Default"
        elseif SelectMaterial=="Fish Tail"then MMon={"Fishman Raider","Fishman Captain"}MPos=CFrame.new(-10941,332,-8760)SP="Default"
        elseif SelectMaterial=="Mini Tusk"then MMon={"Forest Pirate","Mythological Pirate"}MPos=CFrame.new(-13446,413,-7760)SP="Default"
        end
    end
end

QuestNeta = function()
    local questData = GetQuests()
    return {[1] = questData.Mob, [2] = questData.ID, [3] = questData.NameQuest, [4] = questData.LevelReq, [5] = questData.Mob, [6] = GetQuestPoint()}
end

-- ============================================

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

-- Auto stats: Melee -> 2800 then Defense
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
    while task.wait(0.3) do
        pcall(function()
            local char = plr.Character or plr.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            if not hrp then return end

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
                    end
                else
                    replicated.Remotes.CommF_:InvokeServer("StartQuest", questName, questId)
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
    end
end)

-- ============================================

