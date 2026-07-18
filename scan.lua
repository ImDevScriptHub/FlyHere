-- NEURAL-LINK: SCANNER (Для пошуку назв об'єктів)
local function scanWorkspace()
    print("--- SCANNING WORKSPACE ---")
    local count = 0
    for _, obj in pairs(game.Workspace:GetChildren()) do
        -- Фільтруємо сміття, залишаємо тільки частини
        if obj:IsA("BasePart") then
            print("Found object: " .. obj.Name)
            count = count + 1
        end
    end
    print("--- SCAN COMPLETE. Found " .. count .. " parts. ---")
end

scanWorkspace()
