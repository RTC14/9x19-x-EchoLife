-- ================================================
-- BRAINROT HISTORY GUI - ECHOLEAF + WEBSOCKET
-- ================================================

local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local HttpService     = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local Workspace       = game:GetService("Workspace")

local player = Players.LocalPlayer

local WS_URL = "wss://joiner-production-b6dd.up.railway.app"

local COLORS = {
    Background = Color3.fromRGB(8, 8, 18),
    SectionBG  = Color3.fromRGB(20, 20, 35),
    TextWhite  = Color3.fromRGB(255, 255, 255),
    JoinBtn    = Color3.fromRGB(100, 0, 200),
}

local rainbowHue = 0
local rainbowElements = {}

local function playClickSound()
    task.spawn(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://94753039770005"
        sound.Volume = 1
        sound.Parent = Workspace
        sound:Play()
        sound.Ended:Wait()
        sound:Destroy()
    end)
end

local function makeRainbowGradient(obj)
    local grad = Instance.new("UIGradient")
    grad.Rotation = 45
    grad.Parent = obj
    table.insert(rainbowElements, grad)
    return grad
end

RunService.RenderStepped:Connect(function(dt)
    rainbowHue = (rainbowHue + dt * 0.4) % 1
    for _, grad in ipairs(rainbowElements) do
        if grad and grad.Parent then
            local c1 = Color3.fromHSV(rainbowHue, 1, 1)
            local c2 = Color3.fromHSV((rainbowHue + 0.33) % 1, 1, 1)
            local c3 = Color3.fromHSV((rainbowHue + 0.66) % 1, 1, 1)
            grad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(0.5, c2), ColorSequenceKeypoint.new(1, c3)})
            grad.Rotation = (grad.Rotation + 1.8) % 360
        end
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "EchoLeaf_BrainrotHistory"
ScreenGui.ResetOnSpawn = false
if gethui then ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui); ScreenGui.Parent = game.CoreGui
else ScreenGui.Parent = player:WaitForChild("PlayerGui") end

-- ================================================
-- ✅ STATUS INDICATOR (esquina izquierda)
-- ================================================
local statusGui = Instance.new("Frame")
statusGui.Size = UDim2.new(0, 130, 0, 32)
statusGui.Position = UDim2.new(0, 10, 0, 10)
statusGui.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
statusGui.BorderSizePixel = 0
statusGui.Parent = ScreenGui
Instance.new("UICorner", statusGui).CornerRadius = UDim.new(0, 10)

local statusStroke = Instance.new("UIStroke", statusGui)
statusStroke.Color = Color3.fromRGB(80, 80, 120)
statusStroke.Thickness = 1.2

local statusDotLeft = Instance.new("Frame", statusGui)
statusDotLeft.Size = UDim2.new(0, 10, 0, 10)
statusDotLeft.Position = UDim2.new(0, 10, 0.5, -5)
statusDotLeft.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
statusDotLeft.BorderSizePixel = 0
Instance.new("UICorner", statusDotLeft).CornerRadius = UDim.new(1, 0)

local statusTextLeft = Instance.new("TextLabel", statusGui)
statusTextLeft.Size = UDim2.new(1, -28, 1, 0)
statusTextLeft.Position = UDim2.new(0, 26, 0, 0)
statusTextLeft.BackgroundTransparency = 1
statusTextLeft.Text = "Status 🔴"
statusTextLeft.TextColor3 = Color3.fromRGB(255, 80, 80)
statusTextLeft.TextSize = 13
statusTextLeft.Font = Enum.Font.GothamBold
statusTextLeft.TextXAlignment = Enum.TextXAlignment.Left

-- Loop status (archivo + websocket)
local botLastPing = 0
task.spawn(function()
    while true do
        pcall(function()
            -- Chequear por archivo
            if readfile then
                local ok, data = pcall(readfile, "bot_status.json")
                if ok and data and data ~= "" then
                    local decoded = HttpService:JSONDecode(data)
                    if decoded and decoded.lastPing then
                        botLastPing = decoded.lastPing
                    end
                end
            end
            -- Actualizar visual
            if (os.time() - botLastPing) < 15 then
                statusTextLeft.Text = "Status 🟢"
                statusTextLeft.TextColor3 = Color3.fromRGB(0, 255, 150)
                statusDotLeft.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
                statusStroke.Color = Color3.fromRGB(0, 180, 100)
            else
                statusTextLeft.Text = "Status 🔴"
                statusTextLeft.TextColor3 = Color3.fromRGB(255, 80, 80)
                statusDotLeft.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
                statusStroke.Color = Color3.fromRGB(80, 80, 120)
            end
        end)
        task.wait(5)
    end
end)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 420, 0, 460)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -230)
MainFrame.BackgroundColor3 = COLORS.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 26)

local AnimatedStroke = Instance.new("UIStroke")
AnimatedStroke.Thickness = 3.5
AnimatedStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
AnimatedStroke.Parent = MainFrame
makeRainbowGradient(AnimatedStroke)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "📋 EchoLeaf Brainrot History"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 17
Title.TextColor3 = COLORS.TextWhite
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Position = UDim2.new(0, 20, 0, 0)
Title.BackgroundTransparency = 1
Title.Parent = Header
makeRainbowGradient(Title)

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0, 95, 0, 28)
RefreshBtn.Position = UDim2.new(1, -130, 0.5, -14)
RefreshBtn.BackgroundColor3 = COLORS.SectionBG
RefreshBtn.Text = "🔄 Refresh"
RefreshBtn.TextColor3 = COLORS.TextWhite
RefreshBtn.Font = Enum.Font.GothamBold
RefreshBtn.TextSize = 13
RefreshBtn.Parent = Header
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 8)
makeRainbowGradient(RefreshBtn)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
CloseBtn.BackgroundColor3 = COLORS.SectionBG
CloseBtn.Text = "X"
CloseBtn.TextColor3 = COLORS.TextWhite
CloseBtn.Font = Enum.Font.GothamBlack
CloseBtn.TextSize = 14
CloseBtn.Parent = Header
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Size = UDim2.new(1, -20, 1, -70)
LogScroll.Position = UDim2.new(0, 10, 0, 60)
LogScroll.BackgroundTransparency = 1
LogScroll.ScrollBarThickness = 4
LogScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 0, 255)
LogScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogScroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = LogScroll

local NoResults = Instance.new("TextLabel")
NoResults.Size = UDim2.new(1, 0, 1, 0)
NoResults.BackgroundTransparency = 1
NoResults.Text = "Aún no hay brainrots guardados.\nEjecuta el bot principal primero."
NoResults.TextColor3 = Color3.fromRGB(140, 100, 255)
NoResults.TextSize = 15
NoResults.Font = Enum.Font.Gotham
NoResults.Parent = LogScroll

-- DRAG
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function() dragging = false end)

-- MINI FRAME
local isMinimized = false
local MiniFrame = Instance.new("Frame")
MiniFrame.Size = UDim2.new(0, 260, 0, 40)
MiniFrame.Position = UDim2.new(0.5, -130, 0.05, 0)
MiniFrame.BackgroundColor3 = COLORS.Background
MiniFrame.Visible = false
MiniFrame.Parent = ScreenGui
Instance.new("UICorner", MiniFrame).CornerRadius = UDim.new(1, 0)

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Thickness = 2.5
MiniStroke.Parent = MiniFrame
makeRainbowGradient(MiniStroke)

local MiniTitle = Instance.new("TextLabel")
MiniTitle.Text = "EchoLeaf History"
MiniTitle.Font = Enum.Font.GothamBold
MiniTitle.TextColor3 = COLORS.TextWhite
MiniTitle.TextSize = 13
MiniTitle.BackgroundTransparency = 1
MiniTitle.Size = UDim2.new(0.65, 0, 1, 0)
MiniTitle.Position = UDim2.new(0, 15, 0, 0)
MiniTitle.TextXAlignment = Enum.TextXAlignment.Left
MiniTitle.Parent = MiniFrame
makeRainbowGradient(MiniTitle)

local MiniOpenBtn = Instance.new("TextButton")
MiniOpenBtn.Size = UDim2.new(0, 26, 0, 26)
MiniOpenBtn.Position = UDim2.new(1, -32, 0.5, -13)
MiniOpenBtn.BackgroundColor3 = COLORS.SectionBG
MiniOpenBtn.Text = "O"
MiniOpenBtn.TextColor3 = COLORS.TextWhite
MiniOpenBtn.Font = Enum.Font.GothamBold
MiniOpenBtn.TextSize = 14
MiniOpenBtn.Parent = MiniFrame
Instance.new("UICorner", MiniOpenBtn).CornerRadius = UDim.new(1, 0)

-- ================================================
-- ✅ CARGAR DESDE ARCHIVO (CROSS-SERVER fallback)
-- ================================================
local function loadFromFile()
    pcall(function()
        if not readfile then return end
        local ok, data = pcall(readfile, "brainrot_history.json")
        if not ok or not data or data == "" then return end
        local decoded = HttpService:JSONDecode(data)
        if not decoded or type(decoded) ~= "table" or #decoded == 0 then return end
        if not getgenv().BrainrotDiscoveries then
            getgenv().BrainrotDiscoveries = {}
        end
        local existingKeys = {}
        for _, e in ipairs(getgenv().BrainrotDiscoveries) do
            existingKeys[e.jobId.."|"..e.name.."|"..tostring(e.value)] = true
        end
        for _, e in ipairs(decoded) do
            local key = e.jobId.."|"..e.name.."|"..tostring(e.value)
            if not existingKeys[key] then
                table.insert(getgenv().BrainrotDiscoveries, e)
                existingKeys[key] = true
            end
        end
        while #getgenv().BrainrotDiscoveries > 100 do
            table.remove(getgenv().BrainrotDiscoveries, 1)
        end
    end)
end

-- Crear fila
local function createHistoryRow(entry)
    local isOtherServer = entry.jobId ~= game.JobId

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 66)
    row.BackgroundColor3 = isOtherServer and Color3.fromRGB(18, 18, 32) or COLORS.SectionBG
    row.BorderSizePixel = 0
    row.ClipsDescendants = true
    row.Parent = LogScroll
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Thickness = 1.5
    rowStroke.Parent = row
    makeRainbowGradient(rowStroke)

    local shimmer = Instance.new("Frame")
    shimmer.Size = UDim2.new(0, 60, 2, 0)
    shimmer.Position = UDim2.new(-0.3, 0, -0.5, 0)
    shimmer.BackgroundColor3 = Color3.fromRGB(255,255,255)
    shimmer.BackgroundTransparency = 0.75
    shimmer.Rotation = 30
    shimmer.ZIndex = 2
    shimmer.Parent = row
    local sGrad = Instance.new("UIGradient")
    sGrad.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.4,0.3), NumberSequenceKeypoint.new(1,1)}
    sGrad.Parent = shimmer
    TweenService:Create(shimmer, TweenInfo.new(2.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Position = UDim2.new(1.3, 0, -0.5, 0)}):Play()

    local timeLbl = Instance.new("TextLabel")
    timeLbl.Text = "🕒 " .. entry.timestamp .. (isOtherServer and "  📡 Otro server" or "  ✅ Este server")
    timeLbl.Size = UDim2.new(1, -20, 0, 16)
    timeLbl.Position = UDim2.new(0, 12, 0, 4)
    timeLbl.BackgroundTransparency = 1
    timeLbl.TextColor3 = isOtherServer and Color3.fromRGB(255, 180, 0) or Color3.fromRGB(160, 120, 255)
    timeLbl.TextSize = 11
    timeLbl.Font = Enum.Font.Gotham
    timeLbl.TextXAlignment = Enum.TextXAlignment.Left
    timeLbl.Parent = row

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Text = (entry.count or 1) .. "x " .. entry.name
    nameLbl.Size = UDim2.new(0.58, 0, 0, 22)
    nameLbl.Position = UDim2.new(0, 12, 0, 22)
    nameLbl.BackgroundTransparency = 1
    nameLbl.TextColor3 = COLORS.TextWhite
    nameLbl.TextSize = 14
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.Parent = row

    local moneyStr = entry.value >= 1e9 and string.format("$%.2fB/s", entry.value/1e9) or string.format("$%.0fM/s", entry.value/1e6)
    local moneyLbl = Instance.new("TextLabel")
    moneyLbl.Text = moneyStr
    moneyLbl.Size = UDim2.new(0.3, 0, 0, 22)
    moneyLbl.Position = UDim2.new(0.6, 0, 0, 22)
    moneyLbl.BackgroundTransparency = 1
    moneyLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
    moneyLbl.TextSize = 14
    moneyLbl.Font = Enum.Font.GothamBold
    moneyLbl.TextXAlignment = Enum.TextXAlignment.Right
    moneyLbl.Parent = row

    local jobLbl = Instance.new("TextLabel")
    jobLbl.Text = "🔑 " .. (entry.jobId and entry.jobId:sub(1,14).."..." or "N/A")
    jobLbl.Size = UDim2.new(0.7, 0, 0, 14)
    jobLbl.Position = UDim2.new(0, 12, 0, 46)
    jobLbl.BackgroundTransparency = 1
    jobLbl.TextColor3 = Color3.fromRGB(100, 100, 160)
    jobLbl.TextSize = 10
    jobLbl.Font = Enum.Font.Gotham
    jobLbl.TextXAlignment = Enum.TextXAlignment.Left
    jobLbl.Parent = row

    local joinBtn = Instance.new("TextButton")
    joinBtn.Size = UDim2.new(0, 72, 0, 30)
    joinBtn.Position = UDim2.new(1, -85, 0.5, -15)
    joinBtn.BackgroundColor3 = isOtherServer and Color3.fromRGB(180, 100, 0) or COLORS.JoinBtn
    joinBtn.Text = isOtherServer and "JOIN 📡" or "JOIN"
    joinBtn.TextColor3 = Color3.new(1,1,1)
    joinBtn.Font = Enum.Font.GothamBlack
    joinBtn.TextSize = 13
    joinBtn.Parent = row
    Instance.new("UICorner", joinBtn).CornerRadius = UDim.new(0, 6)
    makeRainbowGradient(joinBtn)

    joinBtn.MouseButton1Click:Connect(function()
        playClickSound()
        joinBtn.Text = "JOINING..."
        -- ✅ ANTI-ERROR: teleport con pcall
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, entry.jobId, player)
        end)
        task.delay(2.5, function()
            if joinBtn and joinBtn.Parent then
                joinBtn.Text = isOtherServer and "JOIN 📡" or "JOIN"
            end
        end)
    end)

    return row
end

local function addEntryToHistory(entry)
    if not getgenv().BrainrotDiscoveries then
        getgenv().BrainrotDiscoveries = {}
    end
    local key = entry.jobId.."|"..entry.name.."|"..tostring(entry.value)
    for _, e in ipairs(getgenv().BrainrotDiscoveries) do
        if e.jobId.."|"..e.name.."|"..tostring(e.value) == key then return end
    end
    table.insert(getgenv().BrainrotDiscoveries, entry)
    if #getgenv().BrainrotDiscoveries > 100 then
        table.remove(getgenv().BrainrotDiscoveries, 1)
    end
end

local function updateHistory()
    loadFromFile()
    for _, child in ipairs(LogScroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    local discoveries = getgenv().BrainrotDiscoveries or {}
    if #discoveries == 0 then
        NoResults.Visible = true
        return
    end
    NoResults.Visible = false
    for i = #discoveries, 1, -1 do
        createHistoryRow(discoveries[i])
    end
end

RefreshBtn.MouseButton1Click:Connect(function() playClickSound(); updateHistory() end)
CloseBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isMinimized = not isMinimized
    MainFrame.Visible = not isMinimized
    MiniFrame.Visible = isMinimized
end)
MiniOpenBtn.MouseButton1Click:Connect(function()
    playClickSound()
    isMinimized = false
    MiniFrame.Visible = false
    MainFrame.Visible = true
end)

-- ✅ WEBSOCKET: recibir brainrots en tiempo real del bot
task.spawn(function()
    while true do
        pcall(function()
            local ws
            if WebSocket and WebSocket.connect then
                ws = WebSocket.connect(WS_URL)
            elseif syn and syn.websocket and syn.websocket.connect then
                ws = syn.websocket.connect(WS_URL)
            end
            if ws then
                ws.OnMessage:Connect(function(msg)
                    pcall(function()
                        local data = HttpService:JSONDecode(msg)
                        if not data then return end

                        -- Actualizar status si es ping
                        if data.type == "ping" and data.lastPing then
                            botLastPing = data.lastPing
                        end

                        -- Agregar al historial si es brainrot
                        if data.type == "brainrot" then
                            addEntryToHistory({
                                timestamp = data.timestamp or os.date("%Y-%m-%d %H:%M:%S"),
                                jobId = data.jobId,
                                name = data.name,
                                value = data.value,
                                count = data.count or 1
                            })
                            -- Si hay otros brainrots, agregarlos también
                            if data.others then
                                for _, br in ipairs(data.others) do
                                    if br.name ~= data.name then
                                        addEntryToHistory({
                                            timestamp = data.timestamp or os.date("%Y-%m-%d %H:%M:%S"),
                                            jobId = data.jobId,
                                            name = br.name,
                                            value = br.value,
                                            count = br.count or 1
                                        })
                                    end
                                end
                            end
                            -- Actualizar GUI inmediatamente
                            updateHistory()
                        end
                    end)
                end)
            end
        end)
        task.wait(10) -- reconectar si se cae
    end
end)

-- Loop actualización
task.spawn(function()
    while true do
        updateHistory()
        task.wait(3)
    end
end)

print("✅ EchoLeaf History - WebSocket + Status + Cross-Server enabled")
