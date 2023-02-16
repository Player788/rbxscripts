
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
if getCode or getBypass and game.PlaceId ~= 6860481136 then
	player:Kick("Failed to bypass")
	return
end
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/Player788/Exec-UI-Library/main/src.lua'))()
local Window = Library:Window({
	Name = "Attack on Titan Last Breath", 
	Creator = "Player788",
	Script = "Levi",
	Sounds = true,
})
Library:Notification{Title = "Attack on Titan Last Breath", Content = "Eren Mission not yet supported", Time = 10}

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
            Library:Notification{Content = "LEVI MODE : ENABLED"}
        else
            Library:Notification{Content = "LEVI MODE : DISABLED"}
        end
        if game.PlaceId == 8196884255 then
            game.Players.LocalPlayer.Character.Humanoid.Health = 0
        end
	end
}
local IG = false
local IG_TOGGLE = LF1:AddToggle{
	Name = "INFINITE CHARGE",
	Default = false,
	Callback = function(Bool)
        IG = Bool
        if Bool then
            Library:Notification{Content = "INFINITE CHARGE : ENABLED"}
        else
            Library:Notification{Content = "INFINITE CHARGE : DISABLED"}
        end
	end
}
local DE = false
local DE_TOGGLE = LF1:AddToggle{
	Name = "DISABLE EFFECTS (No Lag)",
	Default = false,
	Callback = function(Bool)
        DE = Bool
        if Bool then
            Library:Notification{Content = "EFFECTS : ENABLED"}
        else
            Library:Notification{Content = "EFFECTS : DISABLED"}
        end
	end
}
local RF1 = Tab1:RightSection("Titans")
local EN = false
local EN_TOGGLE = RF1:AddToggle{
	Name = "EXPOSE NAPES",
	Default = false,
	Callback = function(Bool)
        EN = Bool
        if Bool then
            Library:Notification{Content = "EXPOSE NAPES : ENABLED"}
        else
            Library:Notification{Content = "EXPOSE NAPES : DISABLED"}
        end
	end
}
local AF = false
local AF_TOGGLE = RF1:AddToggle{
	Name = "AUTO - FARM / KILL TITANS",
	Default = false,
	Callback = function(Bool)
        AF = Bool
        if Bool then
            Library:Notification{Content = "AUTO - FARM / KILL TITANS : ENABLED"}
        else
            Library:Notification{Content = "AUTO - FARM / KILL TITANS : DISABLED"}
        end
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
                if game.PlaceId == 8196884255 then -- Free
                    fireclickdetector(workspace.Charge.ClickDetector)
                elseif game.PlaceId == 3600972202 then -- Town
                    workspace.Settings.Input:FireServer("Charge", 1)
                    fireclickdetector(workspace.Charge2.ClickDetector)
                elseif game.PlaceId == 6860481136 then -- Reiner
                    local cd = workspace.Horses:FindFirstChild(player.Name).Supplies.Reload
                    workspace.Settings.Input:FireServer("ClickDetector", cd)
                end
                
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
            local titans = workspace.Titans
            for i, v in pairs(titans:GetChildren()) do
                pcall(function()
                    if v:FindFirstChild("Nape") and v.Main.Died.Value == false then
                        -- if player:DistanceFromCharacter(v.Nape.Position) < 8 * 10 then
                        --     workspace.Settings.Input:FireServer(code, v.Nape)
                        -- else
                        --     Library:Notification{Content = err}
                        -- end
                        player.Character.HumanoidRootPart.CFrame = CFrame.new(v.Nape.Position) + Vector3.new(0,100,0)
                        workspace.Settings.Input:FireServer(code, v.Nape)
                    end
				end)
            end
        end
    end
end)

spawn(function()
    while wait(5) do
        if DE == true then
            if not player.Character:FindFirstChild("LeftHarpoon") then return end
            for i, v in pairs(player.Character.LeftHarpoon:GetChildren()) do
                if v:IsA("ParticleEmitter") or v:IsA("Decal") or v:IsA("Script") then
                    v:Destroy()
                end
            end
            for i, v in pairs(player.Character.RightHarpoon:GetChildren()) do
                if v:IsA("ParticleEmitter") or v:IsA("Decal") or v:IsA("Script") then
                    v:Destroy()
                end
            end
        else

        end
    end
end)
