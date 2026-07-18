-- NEURAL-LINK CORE | NO-GUI VERSION
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

local points = {}
local fixEnabled = false
local loopTask = nil

-- CORE LOGIC
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
        if loopTask then task.cancel(loopTask) end
        loopTask = task.spawn(function()
            while task.wait(tonumber(args[3])) do
                runCommand(args[1], {args[2]})
            end
        end)
    end
end

-- BACKGROUND ENGINE
RunService.Heartbeat:Connect(function()
    if fixEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
        local hum = player.Character.Humanoid
        if hum.WalkSpeed < 50 then hum.WalkSpeed = 50 end
        if hum.JumpPower < 200 then hum.JumpPower = 200 end
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

print("NEURAL-LINK CORE: READY. USE COMMANDS IN CHAT.")
