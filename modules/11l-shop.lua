-- ============================================
-- MODULE 11l: Shop Tab
-- ============================================

Tabs.Shop:AddSection("Shop Options")
Tabs.Shop:AddButton({
Name = "Buy Buso", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Buso")
end})
Tabs.Shop:AddButton({
Name = "Buy Geppo", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Geppo")
end})
Tabs.Shop:AddButton({
Name = "Buy Soru", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyHaki","Soru")
end})
Tabs.Shop:AddButton({
Name = "Buy Ken", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("KenTalk","Buy")
end})

Tabs.Shop:AddSection("Fighting - Style")
Tabs.Shop:AddButton({
Name = "Buy Black Leg", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyBlackLeg")
end})
Tabs.Shop:AddButton({
Name = "Buy Electro", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyElectro")
end})
Tabs.Shop:AddButton({
Name = "Buy Fishman Karate", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyFishmanKarate")
end})
Tabs.Shop:AddButton({
Name = "Buy DragonClaw", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","DragonClaw","2")
end})
Tabs.Shop:AddButton({
Name = "Buy Superhuman", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuySuperhuman")
end})
Tabs.Shop:AddButton({
Name = "Buy Death Step", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyDeathStep")
end})
Tabs.Shop:AddButton({
Name = "Buy Sharkman Karate", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuySharkmanKarate")
end})
Tabs.Shop:AddButton({
Name = "Buy ElectricClaw", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyElectricClaw")
end})
Tabs.Shop:AddButton({
Name = "Buy DragonTalon", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyDragonTalon")
end})
Tabs.Shop:AddButton({
Name = "Buy Godhuman", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyGodhuman")
end})
Tabs.Shop:AddButton({
Name = "Buy SanguineArt", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuySanguineArt")
end})

Tabs.Shop:AddSection("Accessory")
Tabs.Shop:AddButton({
Name = "Buy Tomoe Ring", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Tomoe Ring")
end})
Tabs.Shop:AddButton({
Name = "Buy Black Cape", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Black Cape")
end})
Tabs.Shop:AddButton({
Name = "Buy Swordsman Hat", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Swordsman Hat")
end})
Tabs.Shop:AddButton({
Name = "Buy Bizarre Rifle", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("Ectoplasm","Buy", 1)
end})
Tabs.Shop:AddButton({
Name = "Buy Ghoul Mask", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("Ectoplasm","Buy", 2)
end})



Tabs.Shop:AddSection("Weapon World1")
Tabs.Shop:AddButton({
Name = "Buy Cutlass", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Cutlass")
end})
Tabs.Shop:AddButton({
Name = "Buy Katana", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Katana")
end})
Tabs.Shop:AddButton({
Name = "Buy Iron Mace", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Iron Mace")
end})   
Tabs.Shop:AddButton({
Name = "Buy Duel Katana", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Duel Katana")
end})   
Tabs.Shop:AddButton({
Name = "Buy Triple Katana", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Triple Katana")
end})  
Tabs.Shop:AddButton({
Name = "Buy Pipe", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Pipe")
end})  
Tabs.Shop:AddButton({
Name = "Buy Dual-Headed Blade", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Dual-Headed Blade")
end})   
Tabs.Shop:AddButton({
Name = "Buy Bisento", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Bisento")
end})  
Tabs.Shop:AddButton({
Name = "Buy Soul Cane", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Soul Cane")
end})
Tabs.Shop:AddButton({
Name = "Buy Slingshot", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Slingshot")
end})
Tabs.Shop:AddButton({
Name = "Buy Musket", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Musket")
end})    
Tabs.Shop:AddButton({
Name = "Buy Dual Flintlock", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Dual Flintlock")
end})   
Tabs.Shop:AddButton({
Name = "Buy Flintlock", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Flintlock")
end})   
Tabs.Shop:AddButton({
Name = "Buy Refined Flintlock", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Refined Flintlock")
end})   
Tabs.Shop:AddButton({
Name = "Buy Cannon", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BuyItem","Cannon")
end}) 
Tabs.Shop:AddButton({
Name = "Buy Kabucha", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Slingshot","2")
end})

Tabs.Shop:AddSection("Fragments shop")
Tabs.Shop:AddButton({
Name = "Buy Refund Stats", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Refund","2")
end})
Tabs.Shop:AddButton({
Name = "Buy Reroll Race", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("BlackbeardReward","Reroll","2")
end})   
Tabs.Shop:AddButton({
Name = "Buy Ghoul Race", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("Ectoplasm"," Change", 4)
end})	
Tabs.Shop:AddButton({
Name = "Buy Cyborg Race (2.5k)", 
Description = "",
Callback = function()
  replicated.Remotes.CommF_:InvokeServer("CyborgTrainer"," Buy")
end})

Tabs.Shop:AddButton({
    Name = "Buy Draco Race",
    Callback = function()
        _tp(CFrame.new(5814.42724609375, 1208.3267822265625, 884.5785522460938))
        local targetPosition = Vector3.new(5814.42724609375, 1208.3267822265625, 884.5785522460938)
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        repeat wait()
        until (character.HumanoidRootPart.Position - targetPosition).Magnitude < 1
        local args = {
            [1] = {
                ["NPC"] = "Dragon Wizard",
                ["Command"] = "DragonRace"
            }
        }
        game:GetService("ReplicatedStorage").Modules.Net:FindFirstChild("RF/InteractDragonQuest"):InvokeServer(unpack(args))
    end
})

