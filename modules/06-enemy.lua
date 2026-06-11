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
