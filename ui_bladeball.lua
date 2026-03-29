-- ╔══════════════════════════════════════════╗
-- ║      TIOO BLADE V1 — UI MODULE           ║
-- ║    Theme : Blue-Purple Blend             ║
-- ╚══════════════════════════════════════════╝

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")

local player = Players.LocalPlayer
local pGui   = player:WaitForChild("PlayerGui")

if pGui:FindFirstChild("TiooBladeV1") then
    pGui.TiooBladeV1:Destroy()
end

-- ═══════════════════════════════════════════
-- THEME — Blue-Purple Blend
-- ═══════════════════════════════════════════
local THEME = {
    BG_DARK      = Color3.fromRGB(8, 8, 14),
    BG_PANEL     = Color3.fromRGB(12, 11, 20),
    BG_CARD      = Color3.fromRGB(18, 16, 30),
    BG_HOVER     = Color3.fromRGB(26, 22, 44),
    BG_ACTIVE    = Color3.fromRGB(38, 30, 72),
    ACCENT       = Color3.fromRGB(110, 100, 255),   -- ungu-biru khas Blade Ball
    ACCENT_GLOW  = Color3.fromRGB(70, 60, 200),
    ACCENT_BLUE  = Color3.fromRGB(80, 140, 255),    -- biru lama Ridho tetap ada
    GREEN        = Color3.fromRGB(50, 210, 120),
    RED          = Color3.fromRGB(255, 70, 70),
    TEXT_PRIMARY = Color3.fromRGB(235, 230, 255),
    TEXT_MUTED   = Color3.fromRGB(130, 120, 170),
    BORDER       = Color3.fromRGB(45, 38, 75),
    SIDEBAR      = Color3.fromRGB(10, 9, 18),
}

-- ═══════════════════════════════════════════
-- UTILITY
-- ═══════════════════════════════════════════
local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color or THEME.BORDER
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = obj
    return s
end

local function gradient(obj, c0, c1, rotation)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(c0, c1)
    g.Rotation = rotation or 90
    g.Parent = obj
    return g
end

local function tween(obj, time, props)
    return TweenService:Create(
        obj,
        TweenInfo.new(time, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        props
    )
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch
        ) then
            local delta = input.Position - dragStart
            tween(frame, 0.08, {
                Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            }):Play()
        end
    end)
end

-- ═══════════════════════════════════════════
-- MAIN GUI
-- ═══════════════════════════════════════════
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "TiooBladeV1"
mainGui.ResetOnSpawn = false
mainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mainGui.Parent = pGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainWindow"
mainFrame.Size = UDim2.new(0, 340, 0, 220)
mainFrame.Position = UDim2.new(0.5, -170, 0.5, -110)
mainFrame.BackgroundColor3 = THEME.BG_DARK
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = false
mainFrame.Parent = mainGui
corner(mainFrame, 14)
stroke(mainFrame, THEME.BORDER, 1, 0)

-- Top accent line — gradient biru ke ungu
local topGlow = Instance.new("Frame")
topGlow.Size = UDim2.new(0.5, 0, 0, 2)
topGlow.Position = UDim2.new(0.25, 0, 0, 0)
topGlow.BackgroundColor3 = THEME.ACCENT_BLUE
topGlow.BorderSizePixel = 0
topGlow.Parent = mainFrame
corner(topGlow, 2)
gradient(topGlow, THEME.ACCENT_BLUE, THEME.ACCENT, 90)

-- ═══════════════════════════════════════════
-- HEADER
-- ═══════════════════════════════════════════
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = THEME.BG_PANEL
header.BorderSizePixel = 0
header.Parent = mainFrame
corner(header, 14)

local headerFix = Instance.new("Frame")
headerFix.Size = UDim2.new(1, 0, 0, 10)
headerFix.Position = UDim2.new(0, 0, 1, -10)
headerFix.BackgroundColor3 = THEME.BG_PANEL
headerFix.BorderSizePixel = 0
headerFix.Parent = header

-- Logo box dengan gradient biru-ungu
local logoBox = Instance.new("Frame")
logoBox.Size = UDim2.new(0, 20, 0, 20)
logoBox.Position = UDim2.new(0, 8, 0.5, -10)
logoBox.BackgroundColor3 = THEME.ACCENT_BLUE
logoBox.BorderSizePixel = 0
logoBox.Parent = header
corner(logoBox, 8)
gradient(logoBox, THEME.ACCENT_BLUE, THEME.ACCENT, 135)

local logoText = Instance.new("TextLabel")
logoText.Size = UDim2.new(1, 0, 1, 0)
logoText.BackgroundTransparency = 1
logoText.Text = "T"
logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
logoText.Font = Enum.Font.GothamBold
logoText.TextSize = 11
logoText.Parent = logoBox

local titleMain = Instance.new("TextLabel")
titleMain.Size = UDim2.new(1, -110, 0, 13)
titleMain.Position = UDim2.new(0, 34, 0, 5)
titleMain.BackgroundTransparency = 1
titleMain.Text = "TIOO BLADE V1"
titleMain.TextColor3 = THEME.TEXT_PRIMARY
titleMain.Font = Enum.Font.GothamBold
titleMain.TextSize = 9
titleMain.TextXAlignment = Enum.TextXAlignment.Left
titleMain.Parent = header

local titleSub = Instance.new("TextLabel")
titleSub.Size = UDim2.new(1, -110, 0, 10)
titleSub.Position = UDim2.new(0, 34, 0, 18)
titleSub.BackgroundTransparency = 1
titleSub.Text = "Blade Ball  •  by Tiooprime2"
titleSub.TextColor3 = THEME.TEXT_MUTED
titleSub.Font = Enum.Font.Gotham
titleSub.TextSize = 7
titleSub.TextXAlignment = Enum.TextXAlignment.Left
titleSub.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 20, 0, 20)
closeBtn.Position = UDim2.new(1, -28, 0.5, -10)
closeBtn.BackgroundColor3 = Color3.fromRGB(35, 15, 15)
closeBtn.Text = "✕"
closeBtn.TextColor3 = THEME.RED
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 9
closeBtn.BorderSizePixel = 0
closeBtn.Parent = header
corner(closeBtn, 8)
stroke(closeBtn, THEME.RED, 1, 0.6)

closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = THEME.RED, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, 0.15, {BackgroundColor3 = Color3.fromRGB(35,15,15), TextColor3 = THEME.RED}):Play()
end)

makeDraggable(mainFrame, header)

-- ═══════════════════════════════════════════
-- BODY
-- ═══════════════════════════════════════════
local body = Instance.new("Frame")
body.Size = UDim2.new(1, -10, 1, -38)
body.Position = UDim2.new(0, 5, 0, 34)
body.BackgroundTransparency = 1
body.BorderSizePixel = 0
body.Parent = mainFrame

-- ═══════════════════════════════════════════
-- SIDEBAR
-- ═══════════════════════════════════════════
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 68, 1, 0)
sidebar.BackgroundColor3 = THEME.SIDEBAR
sidebar.BorderSizePixel = 0
sidebar.Parent = body
corner(sidebar, 10)
stroke(sidebar, THEME.BORDER, 1, 0.5)

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 4)
sideLayout.Parent = sidebar

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 5)
sidePad.PaddingBottom = UDim.new(0, 5)
sidePad.PaddingLeft = UDim.new(0, 4)
sidePad.PaddingRight = UDim.new(0, 4)
sidePad.Parent = sidebar

-- ═══════════════════════════════════════════
-- CONTENT PANEL
-- ═══════════════════════════════════════════
local contentPanel = Instance.new("Frame")
contentPanel.Size = UDim2.new(1, -74, 1, 0)
contentPanel.Position = UDim2.new(0, 74, 0, 0)
contentPanel.BackgroundColor3 = THEME.BG_PANEL
contentPanel.BorderSizePixel = 0
contentPanel.Parent = body
corner(contentPanel, 10)
stroke(contentPanel, THEME.BORDER, 1, 0.5)

-- ═══════════════════════════════════════════
-- TAB SYSTEM
-- ═══════════════════════════════════════════
local pages = {}
local activeTab = nil

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 2
    page.ScrollBarImageColor3 = THEME.ACCENT
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = contentPanel

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 4)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 5)
    pad.PaddingBottom = UDim.new(0, 5)
    pad.PaddingLeft = UDim.new(0, 5)
    pad.PaddingRight = UDim.new(0, 5)
    pad.Parent = page

    pages[name] = page
end

local function switchTab(name, tabBtn, icon)
    for _, child in pairs(contentPanel:GetChildren()) do
        if child:IsA("ScrollingFrame") then
            child.Visible = false
        end
    end
    if pages[name] then pages[name].Visible = true end

    for _, child in pairs(sidebar:GetChildren()) do
        if child:IsA("TextButton") then
            tween(child, 0.15, {BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
            child.BackgroundTransparency = 1
            local lbl = child:FindFirstChildOfClass("TextLabel")
            if lbl then lbl.TextColor3 = THEME.TEXT_MUTED end
        end
    end

    if tabBtn then
        tabBtn.BackgroundTransparency = 0
        tween(tabBtn, 0.15, {BackgroundColor3 = THEME.BG_ACTIVE}):Play()
        local lbl = tabBtn:FindFirstChildOfClass("TextLabel")
        if lbl then lbl.TextColor3 = THEME.TEXT_PRIMARY end
    end

    activeTab = name
end

local function createTab(icon, name)
    createPage(name)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 24)
    btn.BackgroundTransparency = 1
    btn.BackgroundColor3 = THEME.BG_ACTIVE
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.Parent = sidebar
    corner(btn, 8)

    -- Accent bar kiri saat aktif
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 2, 0.6, 0)
    accentBar.Position = UDim2.new(0, 0, 0.2, 0)
    accentBar.BackgroundColor3 = THEME.ACCENT
    accentBar.BorderSizePixel = 0
    accentBar.Visible = false
    accentBar.Parent = btn
    corner(accentBar, 2)

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.new(0, 16, 1, 0)
    iconLbl.Position = UDim2.new(0, 6, 0, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 11
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.TextColor3 = THEME.TEXT_MUTED
    iconLbl.Parent = btn

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -26, 1, 0)
    nameLbl.Position = UDim2.new(0, 24, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = THEME.TEXT_MUTED
    nameLbl.Font = Enum.Font.GothamSemibold
    nameLbl.TextSize = 8
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = btn

    btn.MouseButton1Click:Connect(function()
        -- sembunyiin semua accent bar
        for _, child in pairs(sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                local bar = child:FindFirstChild("Frame")
                if bar then bar.Visible = false end
            end
        end
        accentBar.Visible = true
        switchTab(name, btn, icon)
    end)

    btn.MouseEnter:Connect(function()
        if activeTab ~= name then
            tween(btn, 0.1, {BackgroundTransparency = 0, BackgroundColor3 = THEME.BG_HOVER}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if activeTab ~= name then
            tween(btn, 0.1, {BackgroundTransparency = 1}):Play()
        end
    end)

    return btn, pages[name], accentBar
end

-- 4 Tab Blade Ball
local combatBtn,  combatPage,  combatBar  = createTab("⚔️",  "Combat")
local visualBtn,  visualPage,  visualBar  = createTab("👁️",  "Visual")
local moveBtn,    movePage,    moveBar    = createTab("🚀",  "Move")
local miscBtn,    miscPage,    miscBar    = createTab("⚙️",  "Misc")

-- Default tab Combat
combatBar.Visible = true
switchTab("Combat", combatBtn, "⚔️")

-- ═══════════════════════════════════════════
-- OPEN BUTTON (minimized)
-- ═══════════════════════════════════════════
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 46, 0, 46)
openBtn.Position = UDim2.new(0.02, 0, 0.45, 0)
openBtn.BackgroundColor3 = THEME.BG_DARK
openBtn.Text = "T"
openBtn.TextColor3 = THEME.ACCENT
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 22
openBtn.Visible = false
openBtn.BorderSizePixel = 0
openBtn.Parent = mainGui
corner(openBtn, 14)
stroke(openBtn, THEME.ACCENT, 2, 0.3)
makeDraggable(openBtn)

-- ═══════════════════════════════════════════
-- OPEN / CLOSE LOGIC
-- ═══════════════════════════════════════════
local isOpen = true
local closeListeners = {}

local function onClose(fn)
    table.insert(closeListeners, fn)
end

local function closeUI()
    isOpen = false
    for _, fn in pairs(closeListeners) do pcall(fn) end
    tween(mainFrame, 0.2, {Size = UDim2.new(0, 340, 0, 0)}):Play()
    task.delay(0.2, function()
        mainFrame.Visible = false
        openBtn.Visible = true
    end)
end

local function openUI()
    isOpen = true
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 340, 0, 0)
    tween(mainFrame, 0.25, {Size = UDim2.new(0, 340, 0, 220)}):Play()
    openBtn.Visible = false
end

closeBtn.MouseButton1Click:Connect(closeUI)
openBtn.MouseButton1Click:Connect(openUI)

-- Animasi open pertama kali
mainFrame.Size = UDim2.new(0, 340, 0, 0)
tween(mainFrame, 0.35, {Size = UDim2.new(0, 340, 0, 220)}):Play()

-- ═══════════════════════════════════════════
-- ITEM BUILDERS
-- ═══════════════════════════════════════════

local function createToggle(page, name, desc, defaultState, callback)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 36)
    row.BackgroundColor3 = THEME.BG_CARD
    row.BorderSizePixel = 0
    row.Parent = page
    corner(row, 8)
    stroke(row, THEME.BORDER, 1, 0.5)

    -- Accent bar kiri
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 2, 0.6, 0)
    bar.Position = UDim2.new(0, 0, 0.2, 0)
    bar.BackgroundColor3 = defaultState and THEME.ACCENT or THEME.BORDER
    bar.BorderSizePixel = 0
    bar.Parent = row
    corner(bar, 2)

    local nameL = Instance.new("TextLabel")
    nameL.Size = UDim2.new(1, -50, 0, 14)
    nameL.Position = UDim2.new(0, 10, 0, 6)
    nameL.BackgroundTransparency = 1
    nameL.Text = name
    nameL.TextColor3 = THEME.TEXT_PRIMARY
    nameL.Font = Enum.Font.GothamSemibold
    nameL.TextSize = 9
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.Parent = row

    local descL = Instance.new("TextLabel")
    descL.Size = UDim2.new(1, -50, 0, 11)
    descL.Position = UDim2.new(0, 10, 0, 20)
    descL.BackgroundTransparency = 1
    descL.Text = desc or ""
    descL.TextColor3 = THEME.TEXT_MUTED
    descL.Font = Enum.Font.Gotham
    descL.TextSize = 7
    descL.TextXAlignment = Enum.TextXAlignment.Left
    descL.Parent = row

    local switch = Instance.new("Frame")
    switch.Size = UDim2.new(0, 30, 0, 16)
    switch.Position = UDim2.new(1, -38, 0.5, -8)
    switch.BackgroundColor3 = defaultState and THEME.GREEN or THEME.BG_HOVER
    switch.BorderSizePixel = 0
    switch.Parent = row
    corner(switch, 8)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = defaultState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = switch
    corner(knob, 6)

    local state = defaultState or false

    local function toggle()
        state = not state
        if state then
            tween(switch, 0.2, {BackgroundColor3 = THEME.GREEN}):Play()
            tween(knob,   0.2, {Position = UDim2.new(1, -14, 0.5, -6)}):Play()
            tween(row,    0.2, {BackgroundColor3 = Color3.fromRGB(12, 28, 18)}):Play()
            tween(bar,    0.2, {BackgroundColor3 = THEME.ACCENT}):Play()
        else
            tween(switch, 0.2, {BackgroundColor3 = THEME.BG_HOVER}):Play()
            tween(knob,   0.2, {Position = UDim2.new(0, 2, 0.5, -6)}):Play()
            tween(row,    0.2, {BackgroundColor3 = THEME.BG_CARD}):Play()
            tween(bar,    0.2, {BackgroundColor3 = THEME.BORDER}):Play()
        end
        if callback then callback(state) end
    end

    row.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            toggle()
        end
    end)

    return { getState = function() return state end, descLabel = descL }
end

local function createSection(page, title)
    local sec = Instance.new("TextLabel")
    sec.Size = UDim2.new(1, 0, 0, 15)
    sec.BackgroundTransparency = 1
    sec.Text = "  " .. title:upper()
    sec.TextColor3 = THEME.ACCENT
    sec.Font = Enum.Font.GothamBold
    sec.TextSize = 7
    sec.TextXAlignment = Enum.TextXAlignment.Left
    sec.Parent = page
end

-- ═══════════════════════════════════════════
-- EXPORTS
-- ═══════════════════════════════════════════
return {
    THEME         = THEME,
    corner        = corner,
    stroke        = stroke,
    gradient      = gradient,
    tween         = tween,
    makeDraggable = makeDraggable,
    mainGui       = mainGui,
    mainFrame     = mainFrame,
    -- Pages
    combatPage    = combatPage,
    visualPage    = visualPage,
    movePage      = movePage,
    miscPage      = miscPage,
    -- Helpers
    createToggle  = createToggle,
    createSection = createSection,
    -- Open/close
    closeBtn      = closeBtn,
    openBtn       = openBtn,
    isOpen        = function() return isOpen end,
    closeUI       = closeUI,
    openUI        = openUI,
    onClose       = onClose,
}
