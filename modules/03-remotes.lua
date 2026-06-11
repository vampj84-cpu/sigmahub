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
