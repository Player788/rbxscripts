local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Player788/Exec-UI-Library/main/src.lua'))()
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
Library:Notification{Title = "Attack on Titan Last Breath", Content = "Menu only works in OPEN ROAM gamemode!", Time = 10}
local Window = Library:Window({
	Name = "Attack on Titan Last Breath", 
	Creator = "Player788",
	Script = "Levi",
	Sounds = true,
})
repeat wait() until player:HasAppearanceLoaded()
-- repeat wait() until player.Character.Humanoid

local Tab1 = Window:AddTab{
	Name = "Menu",
}
local LF1 = Tab1:LeftSection("Player")
local LM = false
local default_dur = game.Players.LocalPlayer.Info.ODM.Durability.Value
local default_vel = game.Players.LocalPlayer.Backpack.ODM.Velocity.Value
local default_range = game.Players.LocalPlayer.Info.ODM.Range.Value
local default_len = game.Players.LocalPlayer.Info.ODM.Length.Value
local LM_TOGGLE = LF1:AddToggle{
	Name = "LEVI MODE",
	TextColor = Color3.fromRGB(255, 0, 0),
	Default = false,
	Callback = function(Bool)
        LM = Bool
        if Bool then
            game.Players.LocalPlayer.Info.ODM.Durability.Value = 1000
		    game.Players.LocalPlayer.Backpack.ODM.Velocity.Value = 500
		    game.Players.LocalPlayer.Info.ODM.Range.Value = 50000
		    game.Players.LocalPlayer.Info.ODM.Length.Value = 50000
        end
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
	end
}
local IG = false
local IG_TOGGLE = LF1:AddToggle{
	Name = "INFINITE GAS",
	Default = false,
	Callback = function(Bool)
        IG = Bool
	end
}

local RF1 = Tab1:RightSection("Titans")
local EN = false
local EN_TOGGLE = RF1:AddToggle{
	Name = "EXPOSE NAPE",
	Default = false,
	Callback = function(Bool)
        EN = Bool
	end
}
local AF = false
local AF_TOGGLE = RF1:AddToggle{
	Name = "AUTO - FARM",
	Default = false,
	Callback = function(Bool)
        AF = Bool
	end
}

spawn(function()
    while wait(0.1) do
        --if game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
            if LM == true then
                game.Players.LocalPlayer.Info.ODM.Durability.Value = 1000
                game.Players.LocalPlayer.Backpack.ODM.Velocity.Value = 500
                game.Players.LocalPlayer.Info.ODM.Range.Value = 50000
                game.Players.LocalPlayer.Info.ODM.Length.Value = 50000
            elseif LM == false then
                game.Players.LocalPlayer.Info.ODM.Durability.Value = default_dur
                game.Players.LocalPlayer.Backpack.ODM.Velocity.Value = default_vel
                game.Players.LocalPlayer.Info.ODM.Range.Value = default_range
                game.Players.LocalPlayer.Info.ODM.Length.Value = default_len	
            end
       -- end
    end
end)

spawn(function()
    while wait(0.5) do
       -- if game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
            if IG == true then
                fireclickdetector(workspace.Charge.ClickDetector)
            end
       -- end
    end
end)
local dn = 60
spawn(function()
    while wait(3) do
        if EN == true then
            local titans = game.Workspace.Titans
            for i, v in pairs(titans:GetChildren()) do
                local function inc()
                    if v.Name ~= "EREN" and v.Nape then
                        local n = v.Nape
                        n.Transparency = 0.3
                        n.Size = Vector3.new(100, 100, 100)
                    end
                end
                local s, r = pcall(function()
                    inc()
                end)
            end
        elseif EN == false then
            local titans = game.Workspace.Titans
            for i, v in pairs(titans:GetChildren()) do
                pcall(function()
                    if v.Name ~= "EREN" and v.Nape then
                        local n = v.Nape
                        n.Transparency = 1
                        n.Size = Vector3.new(dn, dn, dn)
                    end
                end)
            end
        end
    end
end)

spawn(function()
    while wait(1) do
        if AF == true then
            local titans = workspace.Titans:GetChildren()
            for i, v in pairs(titans:GetChildren()) do
                pcall(function()
                    if v:FindFirstChild("Nape") then
                        if player:DistanceFromCharacter(v.Nape.Position) < 8 * 10 then
                            workspace.Settings.Input:FireServer(code, v.Nape)
                        else
                            Library:Notification{Content = err}
                        end
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(v.Nape.Position) + Vector3.new(0,100,0)
                        workspace.Settings.Input:FireServer(code, v.Nape)
                    end
		end)
            end
        end
    end
end)

-- while wait() do
-- 	if (updatetog3) then
-- 		local titans = workspace.Titans:GetChildren()
-- 		for i = 1, #titans do local v = titans[i]
-- 			local fetch, err = pcall(function()
-- 				return v.Main.Died, v.Nape, player.Character.HumanoidRootPart
-- 			end)
-- 			if (fetch) then
-- 				repeat --wait() until player.Character.Humanoid.Health ~= 0
-- 				pcall(function()
-- 					player.Character.HumanoidRootPart.CFrame = CFrame.new(v.Nape.Position) + Vector3.new(0,100,0)
-- 				end)
-- 				wait()		
-- 				workspace.Settings.Input:FireServer(code, v.Nape)
-- 				until v.Main.Died.Value or not updatetog3 or not v.Nape
-- 			elseif player:DistanceFromCharacter(v.Nape.Position) < 8 * 10 then
-- 				workspace.Settings.Input:FireServer(code, v.Nape)
-- 				wait()
-- 			else
-- 				Library:Notification({Content = err,})
-- 			end
-- 			wait(0.2)
-- 		end
-- 	end
-- 	if (updatetog2) then
-- 		game.Players.LocalPlayer.Info.ODM.Durability.Value = 1000
-- 		game.Players.LocalPlayer.Backpack.ODM.Velocity.Value = 500
-- 		game.Players.LocalPlayer.Info.ODM.Range.Value = 50000
-- 		game.Players.LocalPlayer.Info.ODM.Length.Value = 50000
-- 	else
-- 		game.Players.LocalPlayer.Info.ODM.Durability.Value = default_dur
-- 		game.Players.LocalPlayer.Backpack.ODM.Velocity.Value = default_vel
-- 		game.Players.LocalPlayer.Info.ODM.Range.Value = default_range
-- 		game.Players.LocalPlayer.Info.ODM.Length.Value = default_len	
-- 	end
-- 	if (updatetog1) then
-- 		local titans = game.Workspace.Titans
-- 		for i, v in pairs(titans:GetChildren()) do
-- 			if v.Name ~= "EREN" and v.Nape then
-- 				local n = v.Nape
-- 				n.Transparency = 0.3
-- 				n.Size = Vector3.new(100, 100, 100)
-- 			end
-- 		end
-- 	else
-- 		local titans = game.Workspace.Titans
-- 		for i, v in pairs(titans:GetChildren()) do
-- 			if v.Name ~= "EREN" and v.Nape then
-- 				local n = v.Nape
-- 				n.Transparency = 1
-- 				n.Size = Vector3.new(dn, dn, dn)
-- 			end
-- 		end	
-- 	end
-- 	if (updatetog4) then
-- 		wait(3)
-- 		fireclickdetector(workspace.Charge.ClickDetector)
-- 	end
-- end
