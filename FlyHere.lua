local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ===== UI =====
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "AntiCheatTestUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.5, -110, 0.5, -70)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = false -- будем делать вручную

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "AntiCheat Test"
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.TextColor3 = Color3.new(1,1,1)

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0.9, 0, 0, 40)
flyBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
flyBtn.Text = "Fly: OFF"

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0.4, 0, 0, 25)
closeBtn.Position = UDim2.new(0.55, 0, 0.75, 0)
closeBtn.Text = "Close"

local openBtn = Instance.new("TextButton", screenGui)
openBtn.Size = UDim2.new(0, 100, 0, 30)
openBtn.Position = UDim2.new(0, 10, 0, 10)
openBtn.Text = "Open UI"

-- ===== Drag (с ограничением экрана) =====
local dragging = false
local dragInput, dragStart, startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

title.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		local newPos = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)

		-- Ограничение экрана
		local screenSize = workspace.CurrentCamera.ViewportSize
		local x = math.clamp(newPos.X.Offset, 0, screenSize.X - frame.AbsoluteSize.X)
		local y = math.clamp(newPos.Y.Offset, 0, screenSize.Y - frame.AbsoluteSize.Y)

		frame.Position = UDim2.new(0, x, 0, y)
	end
end)

-- ===== UI логика =====
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
end)

-- ===== Fly система =====
local flying = false
local bv, bg

local control = {
	f = 0, b = 0, l = 0, r = 0, u = 0, d = 0
}

UIS.InputBegan:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.W then control.f = 1 end
	if i.KeyCode == Enum.KeyCode.S then control.b = 1 end
	if i.KeyCode == Enum.KeyCode.A then control.l = 1 end
	if i.KeyCode == Enum.KeyCode.D then control.r = 1 end
	if i.KeyCode == Enum.KeyCode.Space then control.u = 1 end
	if i.KeyCode == Enum.KeyCode.LeftShift then control.d = 1 end
end)

UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.W then control.f = 0 end
	if i.KeyCode == Enum.KeyCode.S then control.b = 0 end
	if i.KeyCode == Enum.KeyCode.A then control.l = 0 end
	if i.KeyCode == Enum.KeyCode.D then control.r = 0 end
	if i.KeyCode == Enum.KeyCode.Space then control.u = 0 end
	if i.KeyCode == Enum.KeyCode.LeftShift then control.d = 0 end
end)

local speed = 50

local function startFly()
	local char = player.Character
	if not char then return end

	local hrp = char:WaitForChild("HumanoidRootPart")

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bv.Velocity = Vector3.zero
	bv.Parent = hrp

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

	RunService:BindToRenderStep("Fly", Enum.RenderPriority.Character.Value, function()
		local cam = workspace.CurrentCamera
		local dir = Vector3.new()

		if control.f == 1 then dir += cam.CFrame.LookVector end
		if control.b == 1 then dir -= cam.CFrame.LookVector end
		if control.l == 1 then dir -= cam.CFrame.RightVector end
		if control.r == 1 then dir += cam.CFrame.RightVector end
		if control.u == 1 then dir += Vector3.new(0,1,0) end
		if control.d == 1 then dir -= Vector3.new(0,1,0) end

		bv.Velocity = dir * speed
		bg.CFrame = cam.CFrame
	end)
end

local function stopFly()
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
	RunService:UnbindFromRenderStep("Fly")
end

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying

	if flying then
		flyBtn.Text = "Fly: ON"
		startFly()
	else
		flyBtn.Text = "Fly: OFF"
		stopFly()
	end
end)
