-- ╔══════════════════════════════════════════╗
-- ║     TIOO BLADE V1 — FEATURES MODULE      ║
-- ║          Auto Parry (Blade Ball)         ║
-- ╚══════════════════════════════════════════╝

-- Ambil UI dari _G, bukan load ulang
local UI = _G.TiooBladeUI

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local localPlayer = Players.LocalPlayer
local character   = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local rootPart    = character:WaitForChild("HumanoidRootPart")

-- ═══════════════════════════════════════════
-- STATE
-- ═══════════════════════════════════════════
local autoParryEnabled = false
local parryConnection  = nil
local lastParry        = 0

-- ═══════════════════════════════════════════
-- UTILITY
-- ═══════════════════════════════════════════
local function getParryRemote()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
        or ReplicatedStorage:FindFirstChild("Events")
        or ReplicatedStorage

    for _, v in pairs(remotes:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local name = v.Name:lower()
            if name:find("parry") or name:find("deflect") or name:find("block") then
                return v
            end
        end
    end
    return nil
end

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
local PARRY_DISTANCE = 20
local PARRY_COOLDOWN = 0.3

local function doParry()
    local now = tick()
    if now - lastParry < PARRY_COOLDOWN then return end
    lastParry = now

    local parryRemote = getParryRemote()
    if parryRemote then
        parryRemote:FireServer()
    else
        local VIM = game:GetService("VirtualInputManager")
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end

local function startAutoParry()
    if parryConnection then parryConnection:Disconnect() end

    parryConnection = RunService.Heartbeat:Connect(function()
        if not autoParryEnabled then return end

        character = localPlayer.Character
        if not character then return end
        rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        local balls = findBalls()
        for _, ball in pairs(balls) do
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
