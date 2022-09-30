local Library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Player788/luau1/main/source.lua')))()
local Window = Library:Window("Rodex", "Attack on Titan Last Breath", "rbxassetid://YourIconId")
local Tab = Window:AddTab("Hitbox")
local Hitbox = Tab:AddSection("Hitbox Expander")
local Tab2 = Window:AddTab("Gear")
local Gear = Tab2:AddSection("Gear Editor")

local player, code = game.Players.LocalPlayer
local getCode,getBypass = true,true
for i,v in pairs(getgc(true)) do
	if type(v) == "table" and rawget(v,"Code") then
		code = v.Code
		getCode = false
	end
end
for i,v in pairs(getgc(true)) do
	if type(v) == "table" and rawget(v,"MaybeHacker") then
		v.MaybeHacker = -math.huge
		getBypass = false
	end
end
if getCode or getBypass then
	player:Kick("Failed to bypass")
	return
end

local dn = 60
local updatetog1
Hitbox:AddToggle({
	Text = "EXPOSE NAPE",
	Default = false,
	Callback = function(Value)
		if (Value) then
			updatetog1 = true
			local titans = game.Workspace.Titans
			for i, v in pairs(titans:GetChildren()) do
				if v.Nape then
					local n = v.Nape
					n.Transparency = 0.3
					n.Size = Vector3.new(100, 100, 100)
				end
			end
		else
			updatetog1 = false
			local titans = game.Workspace.Titans
			for i, v in pairs(titans:GetChildren()) do
				if v.Nape then
					local n = v.Nape
					n.Transparency = 1
					n.Size = Vector3.new(dn, dn, dn)
				end
			end
		end
	end
})

local updatetog3
Hitbox:AddToggle({
	Text = "AUTO FARM",
	Default = false,
	Callback = function(Value)
		updatetog3 = Value
	end
})

local default_dur = game.Players.LocalPlayer.Info.ODM.Durability.Value
local default_vel = game.Players.LocalPlayer.Backpack.ODM.Velocity.Value
local default_range = game.Players.LocalPlayer.Info.ODM.Range.Value
local default_len = game.Players.LocalPlayer.Info.ODM.Length.Value

local updatetog2
Gear:AddToggle({
	Text = "LEVI MODE",
	Default = false,
	Callback = function(Value)
		if (Value) then
			updatetog2 = true
			game.Players.LocalPlayer.Character.Humanoid.Health = 0
		else
			updatetog2 = false
			game.Players.LocalPlayer.Character.Humanoid.Health = 0
		end
	end
})
local updatetog4
Gear:AddToggle({
	Text = "INFINITE GAS",
	Default = false,
	Callback = function(Value)
		updatetog4 = Value
	end
})

while wait() do
	if (updatetog3) then
		local titans = workspace.Titans:GetChildren()
		for i = 1, #titans do local v = titans[i]
			local fetch, err = pcall(function()
				return v.Main.Died, v.Nape, player.Character.HumanoidRootPart
			end)
			if (fetch) then
				repeat --wait() until player.Character.Humanoid.Health ~= 0
				pcall(function()
					player.Character.HumanoidRootPart.CFrame = CFrame.new(v.Nape.Position) + Vector3.new(0,100,0)
				end)
				wait()		
				workspace.Settings.Input:FireServer(code, v.Nape)
				until v.Main.Died.Value or not updatetog3 or not v.Nape
			elseif player:DistanceFromCharacter(v.Nape.Position) < 8 * 10 then
				workspace.Settings.Input:FireServer(code, v.Nape)
				wait()
			else
				Library:Notification({Content = err,})
			end
			wait(0.2)
		end
	end
	if (updatetog2) then
		game.Players.LocalPlayer.Info.ODM.Durability.Value = 1000
		game.Players.LocalPlayer.Backpack.ODM.Velocity.Value = 500
		game.Players.LocalPlayer.Info.ODM.Range.Value = 50000
		game.Players.LocalPlayer.Info.ODM.Length.Value = 50000
	else
		game.Players.LocalPlayer.Info.ODM.Durability.Value = default_dur
		game.Players.LocalPlayer.Backpack.ODM.Velocity.Value = default_vel
		game.Players.LocalPlayer.Info.ODM.Range.Value = default_range
		game.Players.LocalPlayer.Info.ODM.Length.Value = default_len	
	end
	if (updatetog1) then
		local titans = game.Workspace.Titans
		for i, v in pairs(titans:GetChildren()) do
			if v.Name ~= "EREN" and v.Nape then
				local n = v.Nape
				n.Transparency = 0.3
				n.Size = Vector3.new(100, 100, 100)
			end
		end
	else
		local titans = game.Workspace.Titans
		for i, v in pairs(titans:GetChildren()) do
			if v.Name ~= "EREN" and v.Nape then
				local n = v.Nape
				n.Transparency = 1
				n.Size = Vector3.new(dn, dn, dn)
			end
		end	
	end
	if (updatetog4) then
		wait(3)
		fireclickdetector(workspace.Charge.ClickDetector)
	end
end
