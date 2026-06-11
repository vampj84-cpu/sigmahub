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
