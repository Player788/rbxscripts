local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local ClaimMoneyButton = workspace.PlayerTycoons[LocalPlayer.Name .. "Tycoon"].MoneyCollector.ClaimMoneyButton

local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Player788/rbxscripts/main/esp.lua"))()
getgenv().pESP = ESP.new(true)

local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Player788/Exec-Panel/main/src.lua'))()
local Window = Library:Window{
	Name = "Admin", 
	Creator = "PlayerExec",
	Script = "Wasteland Admin",
}
local farm = Window:AddSection{Name = "Farming"}

getgenv().auto_claim_money = false
getgenv().auto_purchase = false

farm:AddToggle{
	Name = "Auto-Claim",
	Callback = function(v)
		getgenv().auto_claim_money = v
		if v then
			Library:Notification{1, Content = "AutoClaim Max range is 500 studs"}
		end
	end
}

farm:AddToggle{
	Name = "Auto-Buttons",
	Callback = function(v)
		getgenv().auto_purchase = v
		if v then
			Library:Notification{1, Content = "AutoButtons Max range is 500 studs"}
		end
	end
}

local esp = Window:AddSection{Name = "ESP"}

esp:AddToggle{
	Name = "Enable",
	Callback = function(v)
		getgenv().pESP.Settings.Enabled = v
	end
}
esp:AddToggle{
    Name = "Names",
    Default = true,
    Callback = function(v)
        getgenv().pESP.Texts.Enabled = v
    end
}
esp:AddToggle{
    Name = "Boxes",
    Callback = function(v)
        getgenv().pESP.Boxes.Enabled = v
    end
}
esp:AddToggle{
    Name = "Tracers",
    Callback = function(v)
        getgenv().pESP.Tracers.Enabled = v
    end
}

spawn(function()
    while wait(2.5) do
        if getgenv().auto_claim_money then
            firetouchinterest(LocalPlayer.Character.LeftLowerLeg, ClaimMoneyButton, 0)
            wait(0.1)
            firetouchinterest(LocalPlayer.Character.LeftLowerLeg, ClaimMoneyButton, 1)
            for i, v in pairs(workspace.Entities:GetChildren()) do
                if v.Name == "Money" then
                    ReplicatedStorage.Events.TycoonEvent:FireServer("ClaimPickables", "Money",
                        v:GetAttribute("PickableValue"))
                    v.Position = LocalPlayer.Character.Head.Position
                    v.BillboardGui.Enabled = false
                end
            end
        end
		
    end
end)
spawn(function()
    while wait(5) do
		if getgenv().auto_purchase then
			for i,v in pairs(workspace.PlayerTycoons[LocalPlayer.Name .. "Tycoon"].Buttons:GetChildren()) do
				if v:FindFirstChild("Button") and v.Button.Color == Color3.fromRGB(100, 160, 95) then
					firetouchinterest(LocalPlayer.Character.LeftLowerLeg, v.Button, 0)
					wait(0.1)
					firetouchinterest(LocalPlayer.Character.LeftLowerLeg, v.Button, 1)
				end
			end
		end
	end
end)
