-- FULL SCRIPT: SPEED, JUMP & TP SYSTEM
local player = game.Players.LocalPlayer
local points = {}

-- UI
local screenGui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 120)
frame.Position = UDim2.new(0.5, -100, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Draggable = true

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1, 0, 1, 0)
status.Text = "Commands active:\n/setp [name]\n/tp [name]\n/jump [power]\n/speed [walkspeed]"
status.TextColor3 = Color3.new(1,1,1)

-- Команди
player.Chatted:Connect(function(msg)
    local args = string.split(msg, " ")
    local cmd = args[1]
    local val = args[2]
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")

    if cmd == "/setp" and val then
        points[val] = hrp.CFrame
        print("Point saved: " .. val)
        
    elseif cmd == "/tp" and val and points[val] then
        hrp.CFrame = points[val]
        
    elseif cmd == "/jump" and val and hum then
        hum.JumpPower = tonumber(val)
        print("JumpPower set to: " .. val)
        
    elseif cmd == "/speed" and val and hum then
        hum.WalkSpeed = tonumber(val)
        print("WalkSpeed set to: " .. val)
        
    elseif cmd == "/helptp" then
        for name, _ in pairs(points) do print("Saved point: " .. name) end
    end
end)
