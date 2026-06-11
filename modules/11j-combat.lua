-- ============================================
-- MODULE 11j: Combat Tab
-- ============================================

Tabs.Combat:AddSection("Combat / AimBot")

local __indexPlayer = Tabs.Combat:AddParagraph("All Players On Server", "")

spawn(function()
    while wait(Sec) do
        pcall(function()
            local playerCount = #game:GetService("Players"):GetPlayers()
            if playerCount == 12 then
                __indexPlayer:SetDesc("All Players : " .. playerCount .. " / 12 [Max]")
            else
                __indexPlayer:SetDesc("All Players : " .. playerCount .. " / 12")
            end
        end)
    end
end)

local __AimBotTurn = Tabs.Combat:AddParagraph("Aimbot Status", "")

Checking_AimStatus = function()
    if _G.AimCam then
        return "Aimbot Camera"
    elseif _G.AimbotGun then
        return "Aimbot Guns"
    else
        return ""
    end
end

spawn(function()
    while wait(0.2) do
        pcall(function()
            if _G.AimMethod then
                if (_G.AimCam or _G.AimbotGun) then
                    __AimBotTurn:SetDesc("Aimbot - " .. Checking_AimStatus() .. " : True")
                else
                    __AimBotTurn:SetDesc("Aimbot - Skills : True")
                end
            else
                __AimBotTurn:SetDesc("Aimbot - Skills : False")
            end
        end)
    end
end)


local PlrList = {}   
for _, v in pairs(game:GetService("Players"):GetChildren()) do
    table.insert(PlrList, v.Name)
end

Tabs.Combat:AddDropdown({
    Name = "Select Players",
    Description = "",
    Options = PlrList,
    Callback = function(Value)
        _G.PlayersList = Value
    end
})

Tabs.Combat:AddToggle({
    Name = "Teleport To Select Players",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.TpPly = Value
        spawn(function()
            pcall(function()
                while _G.TpPly do
                    wait()
                    _tp(game:GetService("Players")[_G.PlayersList].Character.HumanoidRootPart.CFrame)
                end
            end)
        end)
    end
})

Tabs.Combat:AddToggle({
    Name = "Spectate Select Players",
    Description = "",
    Default = false,
    Callback = function(Value)
        SpectatePlys = Value
        spawn(function()
            repeat
                task.wait(0.1)
                if game:GetService("Players"):FindFirstChild(_G.PlayersList) then
                    workspace.Camera.CameraSubject = game:GetService("Players"):FindFirstChild(_G.PlayersList).Character.Humanoid
                end
            until not SpectatePlys
            workspace.Camera.CameraSubject = plr.Character.Humanoid
        end)
    end
})

Tabs.Combat:AddDropdown({
    Name = "Select Aim Method",
    Description = "",
    Options = {"Aim Player","Nearest Aim"},
    Callback = function(Value)
        ABmethod = Value
    end
})

Tabs.Combat:AddToggle({
    Name = "Aimbot Method Skills",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AimMethod = Value
    end
})

spawn(function()
    while wait() do
        pcall(function()
            if _G.AimMethod and ABmethod == "Aim Player" then
                local target = Players:FindFirstChild(getgenv().PlayersList)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    if target.Team ~= plr.Team then
                        MousePos = target.Character.HumanoidRootPart.Position
                    end
                end
            end
        end)
    end
end)
spawn(function()
    while wait() do
        pcall(function()
            if _G.AimMethod and ABmethod == "Nearest Aim" then
                local MaxDistance = math.huge
                for _, v in pairs(Players:GetPlayers()) do
                    if v ~= plr and v.Team ~= plr.Team and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                        local Distance = (v.Character.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                        if Distance < MaxDistance then
                            MaxDistance = Distance
                            MousePos = v.Character.HumanoidRootPart.Position
                        end
                    end
                end
            end
        end)
    end
end)

Tabs.Combat:AddToggle({
    Name = "Aimbot Camera Closet Players",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AimCam = Value
    end
})

task.spawn(function()
    while task.wait(Sec) do
        pcall(function()
            if _G.AimCam then
                local camera = workspace.CurrentCamera
                closestplayer = function()
                    local dist = math.huge
                    local target = nil
                    for _, v in next, ply:GetPlayers() do
                        if v ~= plr then
                            if v.Character and v.Character:FindFirstChild("Head") and _G.AimCam and v.Character.Humanoid.Health > 0 then
                                local Mag = (v.Character.Head.Position - plr.Character.Head.Position).Magnitude
                                if Mag < dist then
                                    dist = Mag
                                    target = v
                                end
                            end
                        end
                    end
                    return target
                end
                repeat
                    task.wait()
                    camera.CFrame = CFrame.new(camera.CFrame.Position, closestplayer().Character.HumanoidRootPart.Position)
                until _G.AimCam == false or Mag > dist
            end
        end)
    end
end)

Tabs.Combat:AddSection("Quests Players")

Tabs.Combat:AddButton({
    Name = "Get player quests",
    Description = "",
    Callback = function()
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
        end)
    end
})

Tabs.Combat:AddToggle({
    Name = "Auto Get PlayerQuest",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoReceivePlayerQuest = Value
    end
})


spawn(function()
    while task.wait(1) do
        if _G.AutoReceivePlayerQuest then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
            end)
        end
    end
end)


Tabs.Combat:AddToggle({
    Name = "Auto Kill Player Quest", 
    Default = false,
    Callback = function(Value)
        _G.AutoPlayerHunter = Value
    end
})

spawn(function()
    while task.wait() do
        if _G.AutoPlayerHunter then
            if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible == false then
                task.wait(0.5)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
            else
                for _, target in pairs(game:GetService("Workspace").Characters:GetChildren()) do
                    if string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, target.Name) then
                        repeat
                            task.wait()
                            if AutoHaki then AutoHaki() end
                            if EquipWeapon then EquipWeapon(_G.SelectWeapon) end
                            Useskill = true
                            
                            _tp(target.HumanoidRootPart.CFrame * CFrame.new(1, 7, 3))
                            
                            target.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                            
                        until _G.AutoPlayerHunter == false or target.Humanoid.Health <= 0
                        
                        Useskill = false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                end
            end
        end
    end
end)





Tabs.Combat:AddToggle({
    Name = "Auto Enable PvP",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AutoPvP = Value
    end
})


spawn(function()
    while task.wait(0.5) do
        if _G.AutoPvP then
            local playerGui = game.Players.LocalPlayer.PlayerGui
            if playerGui and playerGui.Main and playerGui.Main:FindFirstChild("PvpDisabled") then
                if playerGui.Main.PvpDisabled.Visible then
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
                    end)
                end
            end
        end
    end
end)

Tabs.Combat:AddToggle({
    Name = "Auto Safe Mode",
    Default = false,
    Callback = function(Value)
        _G.SafeMode = Value
    end
})

spawn(function()
    while task.wait(0.1) do
        if _G.SafeMode then
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")

            if hrp then
                local targetPos = hrp.CFrame * CFrame.new(0, 1000, 0)
                _tp(targetPos) 
            end
        end
    end
end)

Tabs.Combat:AddSection("LocalPlayer Settings")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local flying = false
local flySpeed = 50
local flyConnection
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local bg, bv

local function setupMobileControls()
    local function updateControlsFromJoystick()
        local character = player.Character
        if not character then return end
        
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        
        local moveDirection = humanoid.MoveDirection
        
        ctrl.f = 0
        ctrl.b = 0
        ctrl.l = 0
        ctrl.r = 0
        
        if moveDirection.Z < -0.1 then
            ctrl.f = 1
        elseif moveDirection.Z > 0.1 then
            ctrl.b = 1
        end
        
        if moveDirection.X < -0.1 then
            ctrl.l = 1
        elseif moveDirection.X > 0.1 then
            ctrl.r = 1
        end
    end
    
    local controlConnection
    controlConnection = RunService.Heartbeat:Connect(function()
        if flying then
            updateControlsFromJoystick()
        else
            if controlConnection then
                controlConnection:Disconnect()
            end
        end
    end)
end

local function toggleFly(value)
    flying = value
    
    if flying then
        if not player.Character then return end
        
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        local rootPart
        
        if player.Character:FindFirstChild("Torso") then
            rootPart = player.Character.Torso
        else
            rootPart = player.Character.UpperTorso
        end
        
        if not humanoid or not rootPart then return end
        
    
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Massless = true
            end
        end
        
      
        local descendantAddedConnection
        descendantAddedConnection = player.Character.DescendantAdded:Connect(function(descendant)
            if flying and descendant:IsA("BasePart") then
                descendant.CanCollide = false
                descendant.Massless = true
            end
        end)
        
        bg = Instance.new("BodyGyro", rootPart)
        bg.P = 9e4
        bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.cframe = rootPart.CFrame
        
        bv = Instance.new("BodyVelocity", rootPart)
        bv.velocity = Vector3.new(0, 0, 0)
        bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        humanoid.PlatformStand = true
        
        setupMobileControls()
        
        flyConnection = RunService.Heartbeat:Connect(function()
            if not flying or not player.Character then
                return
            end
            
      
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
            
            if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
                bv.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f + ctrl.b)) + 
                              ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - 
                              workspace.CurrentCamera.CoordinateFrame.p)) * flySpeed
            else
                bv.velocity = Vector3.new(0, 0, 0)
            end
            
            bg.cframe = workspace.CurrentCamera.CoordinateFrame
        end)
        
        
    else
        if flyConnection then
            flyConnection:Disconnect()
            flyConnection = nil
        end
        
        if player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            
          
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                    part.Massless = false
                end
            end
            
            if bg then bg:Destroy() end
            if bv then bv:Destroy() end
        end
        
        ctrl = {f = 0, b = 0, l = 0, r = 0}
    end
end

local function updateFlySpeed(value)
    flySpeed = value
end

player.CharacterAdded:Connect(function(character)
    wait(1)
    if flying then
        toggleFly(false)
        wait(0.1)
        toggleFly(true)
    end
end)


Tabs.Combat:AddToggle({
    Name = "Enable Fly",
    Default = false,
    Callback = function(Value)
        toggleFly(Value)
    end
})

Tabs.Combat:AddSlider({
    Name = "Speed Fly Mode",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(Value)
        updateFlySpeed(Value)
    end
})

Tabs.Combat:AddToggle({
    Name = "Dash No Cooldown",
    Default = false,
    Callback = function(Value)
        getgenv().DodgeNoCD = Value
    end
})
local function NoCooldown()
    local dodgeScript = game.Players.LocalPlayer.Character:WaitForChild("Dodge")
    for i, v in next, getgc() do
        if typeof(v) == "function" then
            local funcEnv = getfenv(v)
            if funcEnv.script == dodgeScript then
                for i2, v2 in next, getupvalues(v) do
                    if tostring(v2) == "0.4" then
                        setupvalue(v, i2, 0)
                    end
                end
            end
        end
    end
end

Tabs.Combat:AddToggle({
    Name = "Instance Mink V3 [ INF ]",
    Description = "",
    Default = false,
    Callback = function(Value)
        InfAblities = Value
    end
})

spawn(function()
    while wait(.2) do
        pcall(function()
            if InfAblities then
                if not plr.Character.HumanoidRootPart:FindFirstChild("Agility") then
                    local agility = replicated.FX["Agility"]:Clone()
                    agility.Name = "Agility"
                    agility.Parent = plr.Character.HumanoidRootPart
                end
            else
                plr.Character.HumanoidRootPart["Agility"]:Destroy()
            end
        end)
    end
end)

Tabs.Combat:AddToggle({
    Name = "Instance Energy [ INF ]",
    Description = "",
    Default = false,
    Callback = function(Value)
        infEnergy = Value
        if Value then
            getInfinity_Ability("Energy", infEnergy)
        end
    end
})

Tabs.Combat:AddToggle({
    Name = "Instance Soru [ INF ]",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.InfSoru = Value
        if Value then
            getInfinity_Ability("Soru", _G.InfSoru)
        end
    end
})

Tabs.Combat:AddToggle({
    Name = "Instance Observation Range [ INF ]",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.InfiniteObRange = Value
        if Value then
            getInfinity_Ability("Observation", _G.InfiniteObRange)
        end
    end
})

Tabs.Combat:AddToggle({
    Name = "Ignore Same Teams",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.NoAimTeam = Value
    end
})

Tabs.Combat:AddToggle({
    Name = "Accept Allies",
    Description = "",
    Default = false,
    Callback = function(Value)
        _G.AcceptAlly = Value
    end
})

spawn(function()
    while wait(Sec) do
        if _G.AcceptAlly then
            pcall(function()
                for _, v in pairs(ply:GetChildren()) do
                    if v.Name ~= plr.Name and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        replicated:WaitForChild("Remotes"):WaitForChild("CommF_"):InvokeServer("AcceptAlly", v.Name)
                    end
                end
            end)
        end
    end
end)


