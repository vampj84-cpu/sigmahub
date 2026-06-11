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
