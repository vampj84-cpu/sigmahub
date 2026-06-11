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
