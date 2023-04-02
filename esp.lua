local Library = {}
Library.__index = Library
_G.ESPVERSION = "1y"
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
			OutlineColor = Color3.fromRGB(0,0,0),
			TextTransparency = 0.7,
			TextFont = Drawing.Fonts.Monospace, -- UI, System, Plex, Monospace
			DisplayDistance = true,
			DisplayHealth = true,
			DisplayName = true
		},
		Tracers = {
			Enabled = true,
			Type = 1, -- 1 - Bottom; 2 - Center; 3 - Mouse
			Transparency = 0.7,
			Thickness = 1,
			Color = Color3.fromRGB(50, 120, 255)
		},
		Boxes = {
			Enabled = true,
			Color = Color3.fromRGB(50, 120, 255),
			Transparency = 0.7,
			Thickness = 1,
			Filled = false,
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


	local function AddText(Model)
		local Table = GetTable(Model)
		Table.Text = Draw("Text")

		Table.Connections.Text = RunService.RenderStepped:Connect(function()
			local BasePart = Model
			local Vector, OnScreen = Vector2.new(0,0)
			if Players_ESP then
				if Model.Character and Model.Character:FindFirstChild("Humanoid") and Model.Character:FindFirstChild("Head") and Model.Character:FindFirstChild("HumanoidRootPart") then
					BasePart = Model.Character.Head
					Vector, OnScreen = Camera:WorldToViewportPoint(BasePart.Position)
				end
			else
				Vector, OnScreen = Camera:WorldToViewportPoint(BasePart.Position)
			end

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
					Health = 0,
					Distance = "["..tostring(math.floor((BasePart.Position - (LocalPlayer.Character.HumanoidRootPart.Position or Vector3.new(0, 0, 0))).Magnitude)).."]",
					Name = Model.Name
				}

				local Content = ""

				if ESP.Texts.DisplayName then
					Content = Parts.Name..Content
				end
				if ESP.Texts.DisplayHealth and ESP.Texts.DisplayName then
					Content = "(" .. tostring(Model.Character.Humanoid.Health) .. ") " .. Content
				end
				if ESP.Texts.DisplayDistance then
					Content = Content.." "..Parts.Distance
				end

				Table.Text.Text = Content
			end

			if OnScreen then
				if ESP.Texts.Enabled then
					if Players_ESP then
						local Checks = {Alive = true, Team = true}

						if ESP.Texts.AliveCheck then
							Checks.Alive = (Model.Character:FindFirstChild("Humanoid").Health > 0)
						else
							Checks.Alive = true
						end

						if ESP.Settings.TeamCheck then
							Checks.Team = (Model.TeamColor ~= LocalPlayer.TeamColor)
						else
							Checks.Team = true
						end

						if Checks.Alive and Checks.Team then
							Table.Text.Visible = true
						else
							Table.Text.Visible = false
						end
					end
					if Table.Text.Visible then
						UpdateESP()
					end
				end
			else
				Table.Text.Visible = false
			end
		end)
	end

	local function AddBox(Model)
		local Table = GetTable(Model)
		Table.Box = Draw("Square")
		Table.Connections.Box = RunService.RenderStepped:Connect(function()

			local BasePart = Model
			local HRPCFrame, HRPSize
			local Vector, OnScreen
			local HeadOffset, LegsOffset
			if Players_ESP then
				if Model.Character and Model.Character:FindFirstChild("Humanoid") and Model.Character:FindFirstChild("Head") and Model.Character:FindFirstChild("HumanoidRootPart") then
					BasePart = Model.Character.HumanoidRootPart
					HRPCFrame, HRPSize = BasePart.CFrame, BasePart.Size * ESP.Boxes.Increase
					Vector, OnScreen = Camera:WorldToViewportPoint(BasePart.Position)
					HeadOffset = Camera:WorldToViewportPoint(Model.Character.Head.Position + Vector3.new(0, 0.5, 0))
					LegsOffset = Camera:WorldToViewportPoint(Model.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))
				end
			else
				Vector, OnScreen = Camera:WorldToViewportPoint(BasePart.Position)
				HeadOffset = Camera:WorldToViewportPoint(BasePart.Position + Vector3.new(0, 0.5, 0))
				LegsOffset = Camera:WorldToViewportPoint(BasePart.Position - Vector3.new(0, 3, 0))
			end
			--local HeadOffset = Camera:WorldToViewportPoint(Model.Character.Head.Position + Vector3.new(0, 0.5, 0))
			--local LegsOffset = Camera:WorldToViewportPoint(Model.Character.HumanoidRootPart.Position - Vector3.new(0, 3, 0))

			Table.Box.Visible = ESP.Boxes.Enabled
				
				
			local function UpdateBox()
				Table.Box.Thickness = ESP.Boxes.Thickness
				Table.Box.Color = ESP.Boxes.Color
				Table.Box.Transparency = ESP.Boxes.Transparency
				Table.Box.Filled = ESP.Boxes.Filled
				Table.Box.Size = Vector2.new(2000 / Vector.Z, HeadOffset.Y - LegsOffset.Y)
				Table.Box.Position = Vector2.new(Vector.X - Table.Box.Size.X / 2, Vector.Y - Table.Box.Size.Y / 2)
			end

			if OnScreen then
				if ESP.Boxes.Enabled then
					if Players_ESP then
						local Checks = {Alive = true, Team = true}

						if ESP.Texts.AliveCheck then
							Checks.Alive = (Model.Character:FindFirstChild("Humanoid").Health > 0)
						else
							Checks.Alive = true
						end

						if ESP.Settings.TeamCheck then
							Checks.Team = (Model.TeamColor ~= LocalPlayer.TeamColor)
						else
							Checks.Team = true
						end

						if Checks.Alive and Checks.Team then
							Table.Box.Visible = true
						else
							Table.Box.Visible = false
						end
					end

					if Table.Box.Visible then
						UpdateBox()
					end
				end
			else
				Table.Box.Visible = false
			end
		end)
	end

	local function AddTracer(Model)
		local Table = GetTable(Model)
		Table.Tracer = Draw("Line")

		Table.Connections.Tracer = RunService.RenderStepped:Connect(function()
			local BasePart = Model
			local HRPCFrame, HRPSize
			local Vector, OnScreen
			if Players_ESP then
				if Model.Character and Model.Character:FindFirstChild("Humanoid") and Model.Character:FindFirstChild("Head") and Model.Character:FindFirstChild("HumanoidRootPart") then
					BasePart = Model.Character.HumanoidRootPart
					HRPCFrame, HRPSize = BasePart.CFrame, BasePart.Size
					Vector, OnScreen = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(0, -HRPSize.Y, 0).Position)
				end	
			else
				Vector, OnScreen = Camera:WorldToViewportPoint(BasePart.CFrame * CFrame.new(0, -BasePart.Size.Y, 0).Position)
			end

			--local HRPCFrame, HRPSize = BasePart.CFrame, BasePart.Size
			--local Vector, OnScreen = Camera:WorldToViewportPoint(HRPCFrame * CFrame.new(0, -HRPSize.Y, 0).Position)
			Table.Tracer.Visible = ESP.Tracers.Enabled

			local function UpdateTracer()
				Table.Tracer.Thickness = ESP.Tracers.Thickness
				Table.Tracer.Color = ESP.Tracers.Color
				Table.Tracer.Transparency = ESP.Tracers.Transparency

				Table.Tracer.To = Vector2.new(Vector.X, Vector.Y)

				if ESP.Tracers.Type == 1 then
					Table.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
				elseif ESP.Tracers.Type == 2 then
					Table.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
				elseif ESP.Tracers.Type == 3 then
					Table.Tracer.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
				else
					Table.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
				end
			end

			if OnScreen then
				if ESP.Tracers.Enabled then
					if Players_ESP then
						local Checks = {Alive = true, Team = true}

						if ESP.Texts.AliveCheck then
							Checks.Alive = (Model.Character:FindFirstChild("Humanoid").Health > 0)
						else
							Checks.Alive = true
						end

						if ESP.Settings.TeamCheck then
							Checks.Team = (Model.TeamColor ~= LocalPlayer.TeamColor)
						else
							Checks.Team = true
						end

						if Checks.Alive and Checks.Team then
							Table.Tracer.Visible = true
						else
							Table.Tracer.Visible = false
						end
					end


					if Table.Tracer.Visible then
						UpdateTracer()
					end
				end
			else
				Table.Tracer.Visible = false
			end
		end)
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
