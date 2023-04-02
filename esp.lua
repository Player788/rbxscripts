local Library = {}
Library.__index = Library
_G.ESPVERSION = "1p"
setclipboard(_G.ESPVERSION)
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Camera = game:GetService("Workspace").CurrentCamera
local LocalPlayer = Players.LocalPlayer

function Library.new(Players_ESP:boolean, Parent:Instance, Part:string)
	local ESP = {
		Texts = {
			Enabled = true,
			TextColor = Color3.fromRGB(20, 90, 255),
			TextSize = 14,
			Center = true,
			Outline = true,
			OutlineColor = "0, 0, 0",
			TextTransparency = 0.7,
			TextFont = Drawing.Fonts.Monospace, -- UI, System, Plex, Monospace
			DisplayDistance = true,
			DisplayHealth = true,
			DisplayName = true
		},
		Tracers = {
			Enabled = true,
			--Type = 1, -- 1 - Bottom; 2 - Center; 3 - Mouse
			Transparency = 0.7,
			Thickness = 1,
			Color = Color3.fromRGB(50, 120, 255)
		},
		Boxes = {
			Enabled = true,
			--Type = 1; -- 1 - 3D; 2 - 2D;
			Color = Color3.fromRGB(50, 120, 255),--"50, 120, 255",
			Transparency = 0.7,
			Thickness = 1,
			Filled = false, -- For 2D
			Increase = 1
		},
		Settings = {
			Enabled = true,
			TeamCheck = false,
			AliveCheck = true,
		}

	}

	local Connections = {}
	local Wrapped = {}
	local Draw = Drawing.new

	local function GetTable(Model)
		for _, v in next, Wrapped do
			if v.Model == Model then
				return v
			end
		end
	end


	local function AddText(BasePart)
		local Table = GetTable(BasePart)
		Table.Text = Draw("Text")

		Table.Connections.Text = RunService.RenderStepped:Connect(function()
			--if Player.Character and Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("Head") and Player.Character:FindFirstChild("HumanoidRootPart") and Environment.Settings.Enabled then
			local Model = BasePart
			if Players_ESP then
				repeat wait() until BasePart:HasAppearanceLoaded()
				--if BasePart:HasAppearanceLoaded() then
					Model = Model.Character.Head
				--end
				
			end
			local Vector, OnScreen = Camera:WorldToViewportPoint(Model.Position)

			Table.Text.Visible = ESP.Texts.Enabled

			local function UpdateESP()
				Table.Text.Size = ESP.Texts.TextSize
				Table.Text.Center = ESP.Texts.Center
				Table.Text.Outline = ESP.Texts.Outline
				Table.Text.OutlineColor = ESP.Texts.OutlineColor
				Table.Text.Color = ESP.Texts.TextColor
				Table.Text.Transparency = ESP.Texts.TextTransparency
				Table.Text.Font = ESP.Texts.TextFont

				Table.Text.Position = Vector2.new(Vector.X, Vector.Y - 25)

				local Parts = {
					--Health = "("..tostring(Player.Character.Humanoid.Health)..")",
					Distance = "["..tostring(math.floor((Model.Position - (LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0))).Magnitude)).."]",
					Name = Model.Name
				}

				local Content = ""

				if ESP.Texts.DisplayName then
					Content = Parts.Name..Content
				end
				--if Environment.Visuals.ESPSettings.DisplayHealth then
				--	if Environment.Visuals.ESPSettings.DisplayName then
				--		Content = Parts.Health.." "..Content
				--	else
				--		Content = Parts.Health..Content
				--	end
				--end
				if ESP.Texts.DisplayDistance then
					Content = Content.." "..Parts.Distance
				end

				Table.Text.Text = Content
			end

			if OnScreen then
				if ESP.Texts.Enabled then
					--local Checks = {Alive = true, Team = true}

					--if ESP.Texts.AliveCheck then
					--	Checks.Alive = (Player.Character:FindFirstChild("Humanoid").Health > 0)
					--else
					--	Checks.Alive = true
					--end

					--if Environment.Settings.TeamCheck then
					--	Checks.Team = (Player.TeamColor ~= LocalPlayer.TeamColor)
					--else
					--	Checks.Team = true
					--end

					--if Checks.Alive and Checks.Team then
					--	PlayerTable.ESP.Visible = true
					--else
					--	PlayerTable.ESP.Visible = false
					--end

					if Table.Text.Visible then
						UpdateESP()
					end
				end
			else
				Table.Text.Visible = false
			end
			--else
			--PlayerTable.ESP.Visible = false
			--end
		end)
	end

	local function AddBox(BasePart)

	end
	local function AddTracer(BasePart)

	end

	local self = setmetatable({}, {
		__index = function(_, key)
			return ESP[key]
		end,
		__newindex = function(_, key, value)
			ESP[key] = value
		end,
	})

	local function Wrap(Model)
		local Table, Value = nil, {Model = Model, Connections = {}, Text = nil, Tracer = nil, Box = nil}

		for _, v in next, Wrapped do
			if v[1] == Model then
				Table = v
			end
		end

		if not Table then
			Wrapped[#Wrapped + 1] = Value

			AddText(Model)
			AddTracer(Model)
			AddBox(Model)
		end
	end

	local function UnWrap(Model)
		local Table, Index = nil, nil

		for i, v in next, Wrapped do
			if v.Model == Model then
				Table, Index = v, i
			end
		end

		if Table then
			for _, v in next, Table.Connections do
				v:Disconnect()
			end

			Table.Text:Remove()
			Table.Tracer:Remove()
			Table.Box:Remove()

			for _, v in next, Table.Box do
				v:Remove()
			end

			Wrapped[Index] = nil
		end
	end

	local function Load()
		if not Players_ESP then
			local part = Parent:FindFirstChildOfClass("Model"):FindFirstChildOfClass("BasePart")
			for _, v in pairs(Parent:GetChildren()) do
				v = v:FindFirstChild(Part) or part
				UnWrap(v)
			end

			for _, v in pairs(Parent:GetChildren()) do
				v = v:FindFirstChild(Part) or part
				Wrap(v)
			end
			Connections.ChildAdded = Parent.ChildAdded:Connect(function(v)
				v = v:FindFirstChild(Part) or part
				Wrap(v)
			end)
			Connections.ChildRemoving = Parent.ChildRemoved:Connect(function(v)
				v = v:FindFirstChild(Part) or part
				UnWrap(v)
			end)
		else
			for _, v in next, Players:GetPlayers() do
				if v ~= LocalPlayer then
					UnWrap(v)
				end
			end

			for _, v in next, Players:GetPlayers() do
				if v ~= LocalPlayer then
					Wrap(v)
				end
			end

			Connections.PlayerAdded = Players.PlayerAdded:Connect(function(v)
				if v ~= LocalPlayer then
					Wrap(v)
				end
			end)

			Connections.PlayerRemoving = Players.PlayerRemoving:Connect(function(v)
				if v ~= LocalPlayer then
					UnWrap(v)
				end						
			end)
		end
		
	end
	Load()
	return self
end

return Library
