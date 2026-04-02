-- ╔══════════════════════════════════════════╗
-- ║     TIOO BLADE V1 — FEATURES MODULE      ║
-- ║          Auto Parry (Blade Ball)         ║
-- ╚══════════════════════════════════════════╝

local UI = _G.TiooBladeUI

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local character   = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local rootPart    = character:WaitForChild("HumanoidRootPart")

-- ═══════════════════════════════════════════
-- REMOTE — langsung ambil ParryAttempt
-- ═══════════════════════════════════════════
local Remotes      = ReplicatedStorage:WaitForChild("Remotes")
local ParryAttempt = Remotes:WaitForChild("ParryAttempt")

-- ═══════════════════════════════════════════
-- STATE
-- ═══════════════════════════════════════════
local autoParryEnabled = false
local parryConnection  = nil
local lastParry        = 0

-- ═══════════════════════════════════════════
-- UTILITY — cari bola aktif di workspace
-- ═══════════════════════════════════════════
local function findBalls()
    local balls = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("ball") or name:find("blade") or name:find("projectile") then
                if not obj:IsDescendantOf(character) then
                    table.insert(balls, obj)
                end
            end
        end
    end
    return balls
end

local function distanceTo(part)
    if not rootPart or not part or not part.Parent then return math.huge end
    return (rootPart.Position - part.Position).Magnitude
end

-- ═══════════════════════════════════════════
-- CORE AUTO PARRY
-- ═══════════════════════════════════════════
local PARRY_DISTANCE = 25
local PARRY_COOLDOWN = 0.35

local function doParry()
    local now = tick()
    if now - lastParry < PARRY_COOLDOWN then return end
    lastParry = now
    ParryAttempt:FireServer()
end

local function startAutoParry()
    if parryConnection then parryConnection:Disconnect() end

    parryConnection = RunService.Heartbeat:Connect(function()
        if not autoParryEnabled then return end

        character = localPlayer.Character
        if not character then return end
        rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        for _, ball in pairs(findBalls()) do
            if distanceTo(ball) <= PARRY_DISTANCE then
                doParry()
                break
            end
        end
    end)
end

local function stopAutoParry()
    if parryConnection then
        parryConnection:Disconnect()
        parryConnection = nil
    end
end

-- ═══════════════════════════════════════════
-- UI
-- ═══════════════════════════════════════════
UI.createSection(UI.combatPage, "Auto Combat")

UI.createToggle(
    UI.combatPage,
    "Auto Parry",
    "Deflect bola otomatis saat mendekat",
    false,
    function(state)
        autoParryEnabled = state
        if state then
            startAutoParry()
        else
            stopAutoParry()
        end
    end
)

-- ═══════════════════════════════════════════
-- CLEANUP
-- ═══════════════════════════════════════════
UI.onClose(function()
    autoParryEnabled = false
    stopAutoParry()
end)

localPlayer.CharacterAdded:Connect(function(char)
    character = char
    rootPart  = char:WaitForChild("HumanoidRootPart")
    if autoParryEnabled then
        startAutoParry()
    end
end)
