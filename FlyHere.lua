-- NEURAL-LINK V2.0 | FULL CONTROL
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local points = {}
local fixEnabled = false
local autoFarm = false
local loopData = {cmd = nil, val = nil, delay = 1}

-- UI SETUP
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 350)
frame.Position = UDim2.new(0.5, -125, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- LOGIC ENGINE
local function runCommand(cmd, args)
    local hum = player.Character and player.Character:FindFirstChild("Humanoid")
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

    if cmd == "setp" and args[1] then
        points[args[1]] = hrp.CFrame
    elseif cmd == "tp" and args[1] and points[args[1]] then
        hrp.CFrame = points[args[1]]
    elseif cmd == "delp" and args[1] then
        points[args[1]] = nil
    elseif cmd == "jump" and args[1] then
        hum.JumpPower = tonumber(args[1])
    elseif cmd == "speed" and args[1] then
        hum.WalkSpeed = tonumber(args[1])
    elseif cmd == "fixs" then
        fixEnabled = not fixEnabled
    elseif cmd == "loop" and args[1] and args[2] and args[3] then
        loopData = {cmd = args[1], val = args[2], delay = tonumber(args[3])}
        spawn(function()
            while loopData.cmd do
                runCommand(loopData.cmd, {loopData.val})
                task.wait(loopData.delay)
            end
        end)
    end
end

-- AUTOMATION LOOP
RunService.Heartbeat:Connect(function()
    if fixEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        if player.Character.Humanoid.WalkSpeed < 50 then player.Character.Humanoid.WalkSpeed = 50 end
        if player.Character.Humanoid.JumpPower < 200 then player.Character.Humanoid.JumpPower = 200 end
    end
end)

-- CHAT LISTENER
player.Chatted:Connect(function(msg)
    if string.sub(msg, 1, 1) == "/" then
        local args = string.split(string.sub(msg, 2), " ")
        local cmd = table.remove(args, 1)
        runCommand(cmd, args)
    end
end)

-- UI BUTTONS
local function addButton(text, callback)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, (#frame:GetChildren()-2) * 45 + 50)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Text = text
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
end

addButton("Toggle Fixs (/fixs)", function() runCommand("fixs") end)
addButton("AutoFarm", function() autoFarm = not autoFarm end)

print("NEURAL-LINK V2.0 LOADED. COMMANDS READY.")
