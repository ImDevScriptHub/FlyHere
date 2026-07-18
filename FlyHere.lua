-- FULL SCRIPT: FLY + TP SYSTEM
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local points = {}
local flying = false
local speed = 60
local bodyVel, bodyGyro

-- UI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true

local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0.9, 0, 0, 40)
flyBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
flyBtn.Text = "Fly: OFF"

-- Fly Logic
flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "Fly: ON" or "Fly: OFF"
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if flying then
        bodyVel = Instance.new("BodyVelocity", hrp)
        bodyVel.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        bodyVel.Velocity = Vector3.zero
        bodyGyro = Instance.new("BodyGyro", hrp)
        bodyGyro.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
        bodyGyro.CFrame = hrp.CFrame
    else
        if bodyVel then bodyVel:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end)

RunService.Heartbeat:Connect(function()
    if flying and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        local cam = workspace.CurrentCamera
        local dir = Vector3.zero
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
        
        bodyVel.Velocity = dir * speed
        bodyGyro.CFrame = cam.CFrame
    end
end)

-- TP System
player.Chatted:Connect(function(msg)
    local args = string.split(msg, " ")
    if args[1] == "/setp" and args[2] then
        points[args[2]] = player.Character.HumanoidRootPart.CFrame
        print("Point saved: " .. args[2])
    elseif args[1] == "/tp" and args[2] and points[args[2]] then
        player.Character.HumanoidRootPart.CFrame = points[args[2]]
    elseif args[1] == "/helptp" then
        print("Points: ")
        for name, _ in pairs(points) do print(name) end
    end
end)
