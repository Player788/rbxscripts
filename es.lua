local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Player788/luau1/main/source.lua')))()
local Window = Library:Window({Name = "ESDRP", ScriptName = "REDD", Creator = "Player788", Icon = "rbxassetid://2649573307", Hotkey = {"Semicolon", false}, Save = true, SaveFolderName = "Test2"})
local Tab = Window:AddTab("Local")

local Sect = Tab:AddSection("Local")

local tog1 = false
Sect:AddLabel("World")
Sect:AddToggle({
	Text = "DISABLE NLR",
	Callback = function(v)
		tog1 = v
	end    
})
local tps={}
local dd
Sect:AddLabel("Teleports")
Sect:AddTextBox({
	Text = "Save teleport location",
	Default = "Name?",
	Callback = function(v)
		if tps[v] then Library:Notification({Content = "This teleport name already exists"}) return end
		tps[v] = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
		dd:Refresh({v},false)
	end
})
dd = Sect:AddDropDown({
	Text = "Teleports",
	Default = "16",
	Options = {0},
	Callback = function(Value)
		if tps[Value] then
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(tps[Value])
		end
	end
})

Sect:AddLabel("Player")
local dn = game.Players.LocalPlayer.Character.HumanoidRootPart.Size
local tog2 = false
Sect:AddToggle({
	Text = "HITBOX EXPANDER",
	Default = false,
	Callback = function(Value)
		tog2 = Value
	end
})
Sect:AddToggle({
	Text = "INVIS JETPACK [Y]",
	Default = false,
	Callback = function(Value)
		if Value then
			local client = game:GetService("Players").LocalPlayer
			local model = Instance.new("Model")
			model.Name = "Jetpack"
			local main = Instance.new("Part")
			main.Name = "Main"
			main.Parent = model
			model.Parent = game:GetService("Workspace")[client.Name].Util
		else
			local client = game:GetService("Players").LocalPlayer
			game:GetService("Workspace")[client.Name].Util.Jetpack:Destroy()
		end
	end
})
Sect:AddLabel("Stats")
Sect:AddButton({
	Text = "MAX AMMO",
	Callback = function()
		local Player = game:GetService("Players").LocalPlayer
		Player.PlayerData["Pistol Ammo"].Value = 1000;
		Player.PlayerData["Pistol Ammo"].RobloxLocked = true;
		Player.PlayerData["SMG Ammo"].Value = 1000;
		Player.PlayerData["SMG Ammo"].RobloxLocked = true;
		Player.PlayerData["Rifle Ammo"].Value = 1000;
		Player.PlayerData["Rifle Ammo"].RobloxLocked = true;
		Player.PlayerData["Rifle Ammo"].Value = 1000;
		Player.PlayerData["Rifle Ammo"].RobloxLocked = true;
		Player.PlayerData["Heavy Ammo"].Value = 1000;
		Player.PlayerData["Heavy Ammo"].RobloxLocked = true;
	end
})
Sect:AddButton({
	Text = "FILL HUNGER",
	Callback = function()
		local Player = game:GetService("Players").LocalPlayer
		Player.PlayerData["Hunger"].Value = 100;
		Player.PlayerData["Hunger"].RobloxLocked = true;
	end
})
Sect:AddSlider({
	Text = "Walk Speed",
	Min = 0,
	Max = 200,
	Default = game:GetService("Players").LocalPlayer.Character.Humanoid.WalkSpeed,
	Color = Color3.fromRGB(85, 170, 255),
	Callback = function(Value)
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
	end
})
local Tab2 = Window:AddTab("Printers")
local sect2 = Tab2:AddSection("Printers")
sect2:AddLabel("Teleport to active printers")
local btns = {}
function refreshprints()
	for i,v in pairs(btns) do
		v:Destroy()
	end
	local mps = game.Workspace.MoneyPrinters
	for i, v in pairs(mps:GetChildren()) do
		if v:FindFirstChild("Main") and v:FindFirstChild("Int") then
			local but = sect2:AddButton({
				Text = tostring(v.TrueOwner.Value) .. "'s printer, Cash : " .. v.Int.Money.Value,
				Callback = function()
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame  = CFrame.new(v.Main.Position)
				end
			})
			table.insert(btns, but)
		end
	end
end

game.Workspace.MoneyPrinters.ChildAdded:Connect(refreshprints)
game.Workspace.MoneyPrinters.ChildRemoved:Connect(refreshprints)

local Tab3 = Window:AddTab("Loot")
local sect3 = Tab3:AddSection("Entities")
sect3:AddLabel("Teleport to active Loot")
local btns2 = {}
function refreshent()
	for i,v in pairs(btns2) do
		v:Destroy()
	end
	local mps = game.Workspace.Entities
	for i, v in pairs(mps:GetChildren()) do
		if v:FindFirstChild("MeshPart") then
			local text = 'nil'
			if v:FindFirstChild("TrueOwner") and v:FindFirstChild("Int") then
				if v.Int.Uses.Value == 0 then return end
				text = tostring(v.TrueOwner.Value) .. "'s " .. v.Name
			elseif v:FindFirstChild("ToolOwner") and v:FindFirstChild("Int") then
				text = tostring(v.ToolOwner.Value) .. "'s " .. v.Int.Value
			end
			local but = sect3:AddButton({
				Text = text,
				Callback = function()
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame  = CFrame.new(v.MeshPart.Position)
				end
			})
			table.insert(btns2, but)
		end
	end

end

game.Workspace.Entities.ChildAdded:Connect(refreshent)
game.Workspace.Entities.ChildRemoved:Connect(refreshent)

local Tab4 = Window:AddTab("Players")
local sect4 = Tab4:AddSection("Players")
sect4:AddLabel("Teleport to active Players")
local btns3 = {}
function refreshplrs()
	for i,v in pairs(btns3) do
		v:Destroy()
	end
	local mps = game.Players
	for i, v in pairs(mps:GetChildren()) do
		local but = sect4:AddButton({
			Text = v.Name,
			Callback = function()
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame  = CFrame.new(v.Character.HumanoidRootPart.Position)
			end
		})
		table.insert(btns3, but)
	end

end

game.Players.ChildAdded:Connect(refreshent)
game.Workspace.ChildRemoved:Connect(refreshent)
refreshent()
refreshprints()
refreshplrs()
while true do
	if tog1 then
		for i, v in pairs(game.Workspace:GetChildren()) do
			if v.Name == "NL" then
				v.NL.CanCollide = false
				v.NL.RobloxLocked = true;
				v.NL.NL.CanCollide = false
				v.NL.NL.RobloxLocked = true;
			end
		end
	end
	if tog2 then
		local Players = game.Players
		for i, v in pairs(Players:GetChildren()) do
			if v.Name ~= game.Players.LocalPlayer.Name and v.Character:FindFirstChild("HumanoidRootPart") then
				local n = v.Character.HumanoidRootPart
				n.Transparency = 0.3
				n.CanCollide = false
				n.Size = Vector3.new(45, 45, 45)
			end
		end
	else
		local Players = game.Players
		for i, v in pairs(Players:GetChildren()) do
			if v.Name ~= game.Players.LocalPlayer.Name and v.Character:FindFirstChild("HumanoidRootPart") then
				local n = v.Character.HumanoidRootPart
				n.Transparency = 1
				n.CanCollide = true
				n.Size = dn
			end
		end	
	end
	refreshent()
	refreshprints()
	refreshplrs()
	wait(1)
end
