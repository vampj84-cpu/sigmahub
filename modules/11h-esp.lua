-- ============================================
-- MODULE 11h: ESP Tab
-- ============================================

Tabs.Esp:AddSection("Esp")

function isnil(thing)
    return (thing == nil)
end
local function round(n)
    return math.floor(tonumber(n) + 0.5)
end
Number = math.random(1, 1000000)


local plr = game:GetService('Players').LocalPlayer
local replicated = game:GetService("ReplicatedStorage")
local TeamSelf = plr.Team


EspPly = function()
    for _,v in next, game.Players:GetChildren() do
        pcall(function()
            if not isnil(v.Character) then
                if PlayerEsp then
                    if not isnil(v.Character.Head) and not v.Character.Head:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v.Character.Head)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v.Character.Head
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.Code
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Text = (v.Name ..' \n'.. round((plr.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M')
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        if v.Team == TeamSelf then
                            name.TextColor3 = Color3.new(0,0,254)
                        else
                            name.TextColor3 = Color3.new(255,0,0)
                        end
                    else
                        if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                            v.Character.Head['NameEsp'..Number].TextLabel.Text = (v.Name ..' | '.. round((plr.Character.Head.Position - v.Character.Head.Position).Magnitude/3) ..' M\nHealth : ' .. round(v.Character.Humanoid.Health*100/v.Character.Humanoid.MaxHealth) .. '%')
                        end
                    end
                else
                    if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                        v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end
            end
        end)
    end
end


LocationEsp = function() 
    for _,v in next, workspace["_WorldOrigin"].Locations:GetChildren() do
        pcall(function()
            if IslandESP then 
                if (v.Name ~= "Sea") then
                    if not v:FindFirstChild('NameEsp') then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.Code
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(98,252,252)
                        name.Text = (v.Name ..'   \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    else
                        v['NameEsp'].TextLabel.Text = (v.Name ..'   \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    end
                end
            else
                if v:FindFirstChild('NameEsp') then
                    v:FindFirstChild('NameEsp'):Destroy()
                end
            end
        end)
    end
end


DevEsp = function()
    for i,v in next, workspace:GetChildren() do
        pcall(function()
            if DevilFruitESP then
                if string.find(v.Name, "Fruit") then   
                    if not v.Handle:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v.Handle)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v.Handle
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.Code
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(255,255,255)
                        name.Text = (v.Name ..' \n'.. round((plr.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
                    else
                        v.Handle['NameEsp'..Number].TextLabel.Text = ('[' ..v.Name ..']' ..'   \n'.. round((plr.Character.Head.Position - v.Handle.Position).Magnitude/3) ..' M')
                    end
                end
            else
                if v:FindFirstChild('Handle') and v.Handle:FindFirstChild('NameEsp'..Number) then
                    v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                end
            end
        end)
    end
end


flowerEsp = function()
    for i,v in pairs(workspace:GetChildren()) do
        pcall(function()
            if v.Name == "Flower2" or v.Name == "Flower1" then
                if FlowerESP then 
                    if not v:FindFirstChild('NameEsp'..Number) then
                        local bill = Instance.new('BillboardGui',v)
                        bill.Name = 'NameEsp'..Number
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1,200,1,30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new('TextLabel',bill)
                        name.Font = Enum.Font.Code
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1,0,1,0)
                        name.TextYAlignment = 'Top'
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(88, 214, 252)
                        if v.Name == "Flower1" then 
                            name.Text = ("Blue Flower" ..' \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                        elseif v.Name == "Flower2" then
                            name.Text = ("Red Flower" ..' \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                        end
                    else
                        v['NameEsp'..Number].TextLabel.Text = (v.Name ..'   \n'.. round((plr.Character.Head.Position - v.Position).Magnitude/3) ..' M')
                    end
                else
                    if v:FindFirstChild('NameEsp'..Number) then
                        v:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end
            end   
        end)
    end
end


EventIslandEsp = function()
    for i, v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
        pcall(function()
            if EspEventIsland then
                if (v.Name == "Mirage Island" or v.Name =="Prehistoric Island" or v.Name =="Kitsune Island") then
                    if not v:FindFirstChild("NameEsp") then
                        local bill = Instance.new("BillboardGui", v)
                        bill.Name = "NameEsp"
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new("TextLabel", bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = "Top"
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                        name.Text = (v.Name .. "   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. " M")
                    else
                        v.NameEsp.TextLabel.Text = v.Name .. "   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3) .. " M"
                    end
                end
            else
                if v:FindFirstChild("NameEsp") then
                    v:FindFirstChild("NameEsp"):Destroy()
                end
            end
        end)
    end
end


gearEsp = function()
    for _,v in pairs(workspace.Map.MysticIsland:GetDescendants()) do
        pcall(function()
            if ESPGear then
                if v.Name == "Part" and v.Material == Enum.Material.Neon then
                    if not v:FindFirstChild("NameEsp") then
                        local bill = Instance.new("BillboardGui", v)
                        bill.Name = "NameEsp"
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = v
                        bill.AlwaysOnTop = true
                        local name = Instance.new("TextLabel", bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = "Top"
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                        name.Text = ("Gear" .."   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3).. " M")
                    else
                        v["NameEsp"].TextLabel.Text =("Gear" .."   \n" .. round((plr.Character.Head.Position - v.Position).Magnitude / 3).. " M")
                    end
                end
            else
                if v:FindFirstChild("NameEsp") then
                    v:FindFirstChild("NameEsp"):Destroy()
                end
            end
        end)
    end
end


AdvanFruitEsp = function()
    if advanEsp then     
        for _,v in pairs(replicated.NPCs:GetChildren()) do
            if v.Name == "Advanced Fruit Dealer" then
                if not workspace:FindFirstChild("Adv") then
                    Adv = Instance.new("Part")
                    Adv.Name = "Adv"
                    Adv.Transparency = 1
                    Adv.Size = Vector3.new(1,1,1)
                    Adv.Anchored = true
                    Adv.CanCollide = false
                    Adv.Parent = workspace
                    Adv.CFrame = v.HumanoidRootPart.CFrame    
                elseif workspace:FindFirstChild("Adv") then
                    if not Adv:FindFirstChild("NameEsp") then
                        local bill = Instance.new("BillboardGui", Adv)
                        bill.Name = "NameEsp"
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = Adv
                        bill.AlwaysOnTop = true
                        local name = Instance.new("TextLabel", bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = "Top"
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                        name.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")
                    else
                        Adv["NameEsp"].TextLabel.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")    
                    end                              
                end
            end
        end
    else
        if workspace:FindFirstChild("Adv") then
            workspace:FindFirstChild("Adv"):Destroy()
        end    
    end
end


HakiClorEsp = function()
    if ColorEsp then     
        for _,v in pairs(replicated.NPCs:GetChildren()) do
            if v.Name == "Barista Cousin" then
                if not workspace:FindFirstChild("Gay") then
                    Gay = Instance.new("Part")
                    Gay.Name = "Gay"
                    Gay.Transparency = 1
                    Gay.Size = Vector3.new(1,1,1)
                    Gay.Anchored = true
                    Gay.CanCollide = false
                    Gay.Parent = workspace
                    Gay.CFrame = v.HumanoidRootPart.CFrame    
                elseif workspace:FindFirstChild("Gay") then
                    if not Gay:FindFirstChild("NameEsp") then
                        local bill = Instance.new("BillboardGui", Gay)
                        bill.Name = "NameEsp"
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = Gay
                        bill.AlwaysOnTop = true
                        local name = Instance.new("TextLabel", bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = "Top"
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                        name.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")
                    else
                        Gay["NameEsp"].TextLabel.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")    
                    end                              
                end
            end
        end
    else
        if workspace:FindFirstChild("Gay") then
            workspace:FindFirstChild("Gay"):Destroy()
        end    
    end
end


LegenSword = function()
    if LegenS then     
        for _,v in pairs(replicated.NPCs:GetChildren()) do
            if v.Name == "Legendary Sword Dealer" then
                if not workspace:FindFirstChild("Lgd") then
                    Lgd = Instance.new("Part")
                    Lgd.Name = "Lgd"
                    Lgd.Transparency = 1
                    Lgd.Size = Vector3.new(1,1,1)
                    Lgd.Anchored = true
                    Lgd.CanCollide = false
                    Lgd.Parent = workspace
                    Lgd.CFrame = v.HumanoidRootPart.CFrame    
                elseif workspace:FindFirstChild("Lgd") then
                    if not Lgd:FindFirstChild("NameEsp") then
                        local bill = Instance.new("BillboardGui", Lgd)
                        bill.Name = "NameEsp"
                        bill.ExtentsOffset = Vector3.new(0, 1, 0)
                        bill.Size = UDim2.new(1, 200, 1, 30)
                        bill.Adornee = Lgd
                        bill.AlwaysOnTop = true
                        local name = Instance.new("TextLabel", bill)
                        name.Font = "Code"
                        name.FontSize = "Size14"
                        name.TextWrapped = true
                        name.Size = UDim2.new(1, 0, 1, 0)
                        name.TextYAlignment = "Top"
                        name.BackgroundTransparency = 1
                        name.TextStrokeTransparency = 0.5
                        name.TextColor3 = Color3.fromRGB(80, 245, 245)
                        name.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")
                    else
                        Lgd["NameEsp"].TextLabel.Text = (v.Name .."   \n" ..round((plr.Character.Head.Position - v.HumanoidRootPart.Position).Magnitude /3) .." M")    
                    end                              
                end
            end
        end
    else
        if workspace:FindFirstChild("Lgd") then
            workspace:FindFirstChild("Lgd"):Destroy()
        end    
    end
end


ChestEsp = function()
    if ChestESP then
        local CollectionService = game:GetService("CollectionService")
        local Chests = CollectionService:GetTagged("_ChestTagged")        
        for _, Chest in ipairs(Chests) do
            pcall(function()
                local chestPos = Chest:GetPivot().Position
                local distanceMagnitude = (chestPos - plr.Character.Head.Position).Magnitude
                local sanitizedFullName = Chest:GetFullName():gsub("[^%w_]", "_")
                local existingEsp = Chest:FindFirstChild("ChestEspAttachment")                    
                
                if not existingEsp then
                    local attachment = Instance.new("Attachment")
                    attachment.Name = "ChestEspAttachment"
                    attachment.Parent = Chest
                    attachment.Position = Vector3.new(0, 3, 0)                     
                    
                    local nameEsp = Instance.new("BillboardGui")
                    nameEsp.Name = "NameEsp"
                    nameEsp.Size = UDim2.new(0, 200, 0, 30)
                    nameEsp.Adornee = attachment
                    nameEsp.ExtentsOffset = Vector3.new(0, 1, 0)
                    nameEsp.AlwaysOnTop = true
                    nameEsp.Parent = attachment                        
                    
                    local nameLabel = Instance.new("TextLabel")
                    nameLabel.Font = Enum.Font.Code
                    nameLabel.TextSize = 14
                    nameLabel.TextWrapped = true
                    nameLabel.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel.TextYAlignment = Enum.TextYAlignment.Top
                    nameLabel.BackgroundTransparency = 1
                    nameLabel.TextStrokeTransparency = 0.5
                    nameLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
                    nameLabel.Parent = nameEsp
                end
                
                local nameEsp = existingEsp and existingEsp:FindFirstChild("NameEsp")
                if nameEsp then
                    local displayDistance = math.floor(distanceMagnitude / 3)
                    local chestName = Chest.Name:gsub("Label", "")
                    nameEsp.TextLabel.Text = string.format("[%s] %d M", chestName, displayDistance)
                end
            end)
        end
    else
        for _, Chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
            local espAttachment = Chest:FindFirstChild("ChestEspAttachment")
            if espAttachment then
                espAttachment:Destroy()
            end
        end
    end
end


berriesEsp = function()
    if BerryEsp then
        local CollectionService = game:GetService("CollectionService")
        local BerryBushes = CollectionService:GetTagged("BerryBush")
        for _, Bush in ipairs(BerryBushes) do
            pcall(function()
                local bushPosition = Bush.Parent:GetPivot().Position
                for _, BerryName in pairs(Bush:GetAttributes()) do
                    if BerryName then
                        local espPartName = "BerryEspPart_" .. BerryName .. "_" .. tostring(bushPosition)
                        local existingEsp = workspace:FindFirstChild(espPartName)
                        
                        if not existingEsp then
                            existingEsp = Instance.new("Part")
                            existingEsp.Name = espPartName
                            existingEsp.Transparency = 1
                            existingEsp.Size = Vector3.new(1, 1, 1)
                            existingEsp.Anchored = true
                            existingEsp.CanCollide = false
                            existingEsp.Parent = workspace
                            existingEsp.CFrame = CFrame.new(bushPosition)
                        end
                        
                        if not existingEsp:FindFirstChild("NameEsp") then
                            local nameEsp = Instance.new("BillboardGui", existingEsp)
                            nameEsp.Name = "NameEsp"
                            nameEsp.ExtentsOffset = Vector3.new(0, 1, 0)
                            nameEsp.Size = UDim2.new(0, 200, 0, 30)
                            nameEsp.Adornee = existingEsp
                            nameEsp.AlwaysOnTop = true
                            
                            local nameLabel = Instance.new("TextLabel", nameEsp)
                            nameLabel.Font = Enum.Font.Code
                            nameLabel.TextSize = 14
                            nameLabel.TextWrapped = true
                            nameLabel.Size = UDim2.new(1, 0, 1, 0)
                            nameLabel.TextYAlignment = Enum.TextYAlignment.Top
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.TextStrokeTransparency = 0.5
                            nameLabel.TextColor3 = Color3.fromRGB(80, 245, 245)
                        end
                        
                        local nameEsp = existingEsp:FindFirstChild("NameEsp")
                        local distance = (plr.Character.Head.Position - bushPosition).Magnitude / 3
                        if nameEsp then
                            nameEsp.TextLabel.Text = ('[' .. BerryName .. ']' .. " " .. math.round(distance) .. " M")
                        end
                    end
                end
            end)
        end
    else
        for _, v in ipairs(workspace:GetChildren()) do
            if v:IsA("Part") and v.Name:match("BerryEspPart_.*") then
                v:Destroy()
            end
        end
    end
end


Tabs.Esp:AddToggle({
    Name = "Esp Berry",
    Description = "",
    Default = false,
    Callback = function(Value)
        BerryEsp = Value
        if not Value then
            for _, v in ipairs(workspace:GetChildren()) do
                if v:IsA("Part") and v.Name:match("BerryEspPart_.*") then
                    v:Destroy()
                end
            end
        else
            task.spawn(function()
                while BerryEsp do
                    berriesEsp()
                    task.wait()
                end
            end)
        end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Player",
    Description = "",
    Default = false,
    Callback = function(Value)
        PlayerEsp = Value
        if not Value then
            for _,v in next, game.Players:GetChildren() do
                pcall(function()
                    if not isnil(v.Character) and not isnil(v.Character.Head) then
                        if v.Character.Head:FindFirstChild('NameEsp'..Number) then
                            v.Character.Head:FindFirstChild('NameEsp'..Number):Destroy()
                        end
                    end
                end)
            end
        else
            task.spawn(function()
                while PlayerEsp do
                    EspPly()
                    task.wait()
                end
            end)
        end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Chest",
    Description = "",
    Default = false,
    Callback = function(Value)
        ChestESP = Value
        if not Value then
            for _, Chest in ipairs(game:GetService("CollectionService"):GetTagged("_ChestTagged")) do
                local espAttachment = Chest:FindFirstChild("ChestEspAttachment")
                if espAttachment then
                    espAttachment:Destroy()
                end
            end
        else
            task.spawn(function()
                while ChestESP do
                    ChestEsp()
                    task.wait()
                end
            end)
        end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Fruit",
    Description = "",
    Default = false,
    Callback = function(Value)
        DevilFruitESP = Value
        if not Value then
            for i,v in next, workspace:GetChildren() do
                pcall(function()
                    if v:FindFirstChild('Handle') and v.Handle:FindFirstChild('NameEsp'..Number) then
                        v.Handle:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while DevilFruitESP do
                    DevEsp()
                    task.wait()
                end
            end)
        end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Island",
    Description = "",
    Default = false,
    Callback = function(Value)
        IslandESP = Value
        if not Value then
            for _,v in next, workspace["_WorldOrigin"].Locations:GetChildren() do
                pcall(function()
                    if v:FindFirstChild('NameEsp') then
                        v:FindFirstChild('NameEsp'):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while IslandESP do
                    LocationEsp()
                    task.wait()
                end
            end)
        end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Flower",
    Description = "",
    Default = false,
    Callback = function(Value)
        FlowerESP = Value
        if not Value then
            for i,v in pairs(workspace:GetChildren()) do
                pcall(function()
                    if (v.Name == "Flower2" or v.Name == "Flower1") and v:FindFirstChild('NameEsp'..Number) then
                        v:FindFirstChild('NameEsp'..Number):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while FlowerESP do
                    flowerEsp()
                    task.wait()
                end
            end)
        end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Legendary Sword",
    Description = "",
    Default = false,
    Callback = function(Value)
        LegenS = Value
        if not Value then
            if workspace:FindFirstChild("Lgd") then
                workspace:FindFirstChild("Lgd"):Destroy()
            end
        else
            task.spawn(function()
                while LegenS do
                    LegenSword()
                    task.wait()
                end
            end)
        end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Haki Color",
    Description = "",
    Default = false,
    Callback = function(Value)
        ColorEsp = Value
        if not Value then
            if workspace:FindFirstChild("Gay") then
                workspace:FindFirstChild("Gay"):Destroy()
            end
        else
            task.spawn(function()
                while ColorEsp do
                    HakiClorEsp()
                    task.wait()
                end
            end)
        end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Gear",
    Description = "",
    Default = false,
    Callback = function(Value)
        ESPGear = Value
        if not Value then
            for _,v in pairs(workspace.Map.MysticIsland:GetDescendants()) do
                pcall(function()
                    if v:FindFirstChild("NameEsp") then
                        v:FindFirstChild("NameEsp"):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while ESPGear do
                    gearEsp()
                    task.wait()
                end
            end)
        end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp SeaEvent Island",
    Description = "",
    Default = false,
    Callback = function(Value)
        EspEventIsland = Value
        if not Value then
            for i, v in pairs(workspace._WorldOrigin.Locations:GetChildren()) do
                pcall(function()
                    if v:FindFirstChild("NameEsp") then
                        v:FindFirstChild("NameEsp"):Destroy()
                    end
                end)
            end
        else
            task.spawn(function()
                while EspEventIsland do
                    EventIslandEsp()
                    task.wait()
                end
            end)
        end
    end
})

Tabs.Esp:AddToggle({
    Name = "Esp Advanced Dealer",
    Description = "",
    Default = false,
    Callback = function(Value)
        advanEsp = Value
        if not Value then
            if workspace:FindFirstChild("Adv") then
                workspace:FindFirstChild("Adv"):Destroy()
            end
        else
            task.spawn(function()
                while advanEsp do
                    AdvanFruitEsp()
                    task.wait()
                end
            end)
        end
    end
})

