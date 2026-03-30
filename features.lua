-- ╔══════════════════════════════════════════╗
-- ║     TIOO BLADE V1 — FEATURES MODULE      ║
-- ║          Auto Parry (Blade Ball)         ║
-- ╚══════════════════════════════════════════╝

local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Tiooprime2/TiooBladeV1/main/ui.lua"))()

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
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

-- Cari remote parry/deflect di game
local function getParryRemote()
    -- Blade Ball biasanya pake RemoteEvent bernama "Parry" atau "Deflect"
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

-- Cari bola aktif di workspace
local function findBalls()
    local balls = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Blade Ball bola biasanya bernama "Ball", "Blade", atau punya tag tertentu
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:find("ball") or name:find("blade") or name:find("projectile") then
                -- Pastiin bukan bagian karakter sendiri
                if not obj:IsDescendantOf(character) then
                    table.insert(balls, obj)
                end
            end
        end
    end
    return balls
end

-- Hitung jarak ke bola
local function distanceTo(part)
    if not rootPart or not part or not part.Parent then return math.huge end
    return (rootPart.Position - part.Position).Magnitude
end

-- ═══════════════════════════════════════════
-- CORE AUTO PARRY
-- ═══════════════════════════════════════════
local PARRY_DISTANCE = 20   -- jarak trigger (studs)
local PARRY_COOLDOWN = 0.3  -- cooldown antar parry (detik)

local function doParry()
    local now = tick()
    if now - lastParry < PARRY_COOLDOWN then return end
    lastParry = now

    local parryRemote = getParryRemote()
    if parryRemote then
        -- Fire remote parry ke server
        parryRemote:FireServer()
    else
        -- Fallback: simulasi klik/input parry lewat VirtualInputManager jika remote tidak ketemu
        -- (beberapa game pake InputBegan listener di LocalScript)
        local VIM = game:GetService("VirtualInputManager")
        -- Blade Ball default parry = klik kiri / tap
        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.05)
        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end

local function startAutoParry()
    if parryConnection then parryConnection:Disconnect() end

    parryConnection = RunService.Heartbeat:Connect(function()
        if not autoParryEnabled then return end

        -- Update karakter kalau respawn
        character = localPlayer.Character
        if not character then return end
        rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end

        local balls = findBalls()
        for _, ball in pairs(balls) do
            local dist = distanceTo(ball)
            if dist <= PARRY_DISTANCE then
                doParry()
                break -- cukup 1x parry per frame
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
-- UI — TAMBAH KE COMBAT PAGE
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
-- CLEANUP saat UI ditutup / karakter respawn
-- ═══════════════════════════════════════════
UI.onClose(function()
    autoParryEnabled = false
    stopAutoParry()
end)

localPlayer.CharacterAdded:Connect(function(char)
    character = char
    rootPart  = char:WaitForChild("HumanoidRootPart")
    -- restart loop kalau sedang aktif
    if autoParryEnabled then
        startAutoParry()
    end
end)
