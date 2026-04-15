-- ================================================
-- WAOS Finder v4 - Full Edition
-- ================================================
local Players         = game:GetService("Players")
local TweenService    = game:GetService("TweenService")
local HttpService     = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local UserInputService= game:GetService("UserInputService")
local RunService      = game:GetService("RunService")
local GuiService      = game:GetService("GuiService")
local Workspace       = game:GetService("Workspace")

local player       = Players.LocalPlayer
local WS_URL       = "wss://joiner-production-b6dd.up.railway.app"
local SESSION_START= os.time()

-- ✅ ANTI-ERROR SIEMPRE ACTIVO
RunService.RenderStepped:Connect(function()
    pcall(function() GuiService:ClearError() end)
end)

-- ✅ AUTO LOAD
pcall(function()
    local queueTeleport = queue_on_teleport
        or (syn and syn.queue_on_teleport)
        or (fluxus and fluxus.queue_on_teleport)
    if queueTeleport then
        local src = ""
        pcall(function() src = getscriptsource(script) end)
        if src == "" then pcall(function() src = readfile("finder_main.lua") end) end
        if src and src ~= "" then
            pcall(function() if writefile then writefile("finder_main.lua", src) end end)
            Players.LocalPlayer.OnTeleport:Connect(function(state)
                if state == Enum.TeleportState.Started or state == Enum.TeleportState.InProgress then
                    pcall(function() queueTeleport(src) end)
                end
            end)
        else
            Players.LocalPlayer.OnTeleport:Connect(function(state)
                if state == Enum.TeleportState.Started or state == Enum.TeleportState.InProgress then
                    pcall(function()
                        queueTeleport([[pcall(function()
    if isfile and isfile("finder_main.lua") then loadstring(readfile("finder_main.lua"))() end
end)]])
                    end)
                end
            end)
        end
    end
end)

-- ✅ SETTINGS
local SETTINGS_FILE = "waos_finder_settings.json"
local settings = {
    minMoney=1, minForce=100, forceTimeout=10, forceSpeed=0.15,
    autoJoin=false, autoForce=false,
    blacklist={}, autoForceList={}, targetList={},
}
local function saveSettings()
    pcall(function() if writefile then writefile(SETTINGS_FILE, HttpService:JSONEncode(settings)) end end)
end
local function loadSettings()
    pcall(function()
        if isfile and isfile(SETTINGS_FILE) then
            local d = HttpService:JSONDecode(readfile(SETTINGS_FILE))
            for k,v in pairs(d) do if settings[k] ~= nil then settings[k] = v end end
        end
    end)
end
loadSettings()

-- ✅ BRAINROTS POR RAREZA REAL
local BRAINROT_CATEGORIES = {
    ["God"] = {
        "Alessio","Anpali Babel","Antonio","Aquanut","Aquatic Index",
        "Ballerina Peppermintina","Ballerino Lololo","Bambu Bambu Sahur",
        "Belula Beluga","Bombardini Tortinii","Brasilini Berimbini",
        "Brr es Teh Patipum","Bulbito Bandito Traktorito","Cacasito Satalito",
        "Capi Taco","Cappuccino Clownino","Chihuanini Taconini","Cocofanto Elefanto",
        "Corn Corn Corn Sahur","Crabbo Limonetta","Dug dug dug","Espresso Signora",
        "Extinct Ballerina","Frio Ninja","Gattatino Neonino","Gattatino Nyanino",
        "Gattito Tacoto","Girafa Celestre","Granchiello Spiritello","Jacko Jack Jack",
        "Krupuk Pagi Pagi","Las Cappuchinas","Los Bombinitos","Los Chihuaninis",
        "Los Crocodillitos","Los Gattitos","Los Orcalitos","Los Tipi Tacos",
        "Los Tungtungtungcitos","Mastodontico Telepiedone","Matteo","Money Money Man",
        "Mummy Ambalabu","Noo La Polizia","Odin Din Din Dun","Orcalero Orcala",
        "Orcalita Orcala","Pakrahmatmamat","Pakrahmatmatina","Piccione Macchina",
        "Piccionetta Machina","Pop Pop Sahur","Skull Skull Skull","Snailenzo",
        "Squalanana","Statutino Libertino","Tartaruga Cisterna","Tentacolo Tecnico",
        "Tigroligre Frutonni","Tipi Topi Taco","Tractoro Dinosauro","Tralalero Tralala",
        "Tralalita Tralala","Trenostruzzo Turbo 3000","Trippi Troppi Troppa Trippa",
        "Tukanno Bananno","Unclito Samito","Urubini Flamenguini","Vampira Cappuccina",
    },
    ["Secret"] = {
        "Bacuru and Egguru","Brunito Marsito","Burguro And Fryuro","Capitano Moby",
        "Cerberus","Chicleteira Bicicleteira","Chicleteirina Bicicleteirina","Chill Puppy",
        "Chillin chili","Chipso and Queso","Cooki and Milki","Dragon Cannelloni",
        "Dragon Gingerini","Esok Sekolah","Eviledon","Festive 67","Fishino Clownino",
        "Fragrama and Chocrama","Garama and Madundung","Gobblino Uniciclino",
        "Headless Horseman","Hydra Dragon Cannelloni","Jolly jolly Sahur","Ketupat Bros",
        "Ketupat Kepat","Ketchuru and Musturu","La Casa Boo","La Extinct Grande",
        "La Ginger Sekolah","La Grande Combinasion","La Jolly Grande","La Romantic Grande",
        "La Secret Combinasion","La Spooky Grande","La Supreme Combinasion",
        "La Taco Combinasion","Las Sis","Lavadorito Spinito","Los 25","Los 67",
        "Los Bros","Los Burritos","Los Candies","Los Chicleteiras","Los combinasionas",
        "Los Hotspotsitos","Los Jolly Combinasionas","Los Mi Gatitos","Los Mobilis",
        "Los nooo My Hotspotsitos","Los Planitos","Los Primos","Los Puggies",
        "Los Quesadillas","Los Spaghettis","Los Spooky Combinasionas","Los Tacoritas",
        "Love Love Bear","Lovin Rose","Meowl","Mi Gatito","Money Money Puggy",
        "Money Money Reindeer","Naughty Naughty","Noo my Candy","Noo my Heart",
        "Noo my Present","Nuclearo Dinossauro","Orcaledon","Popcuru and Fizzuru",
        "Quesadilla Crocodila","Quesadilla Vampiro","Rang Ring Bus","Reinito Sleighito",
        "Rosey and Teddy","Rosetti Tualetti","Skibidi Toilet","Spaghetti Tualetti",
        "Spooky and Pumpky","Strawberry Elephant","Swag Soda","Swaggy Bros",
        "Tacorita Bicicleta","Tang Tang Keletang","Tictac Sahur","Tralaledon",
        "Tuff Toucan","W or L",
    },
    ["OG"] = {
        "Arcadopus","Celularcini Viciosini","Chicleteira Cupideira","Chicleteira Noelteira",
        "Chimnino","Cupid Cupid Sahur","Cupid Hotspot","DonkeyTurbo Express",
        "Ginger Gerat","Guest 666","Mariachi Corazoni","Mieteteira Bicicleteira",
        "Spinny Hammy",
    },
}

-- COLORES
local BG_COLOR   = Color3.fromRGB(8, 8, 20)
local CARD_COLOR = Color3.fromRGB(18, 18, 35)
local WHITE      = Color3.fromRGB(255, 255, 255)
local JOIN_COL   = Color3.fromRGB(110, 0, 220)
local FORCE_COL  = Color3.fromRGB(65, 0, 145)
local RED_COL    = Color3.fromRGB(185, 30, 30)
local DARK_COL   = Color3.fromRGB(10, 10, 20)

-- RAINBOW
local rainbowHue = 0
local rainbowEls = {}
local function makeRainbow(obj)
    local g = Instance.new("UIGradient"); g.Rotation=45; g.Parent=obj
    table.insert(rainbowEls, g); return g
end
RunService.RenderStepped:Connect(function(dt)
    rainbowHue=(rainbowHue+dt*0.32)%1
    for _,g in ipairs(rainbowEls) do
        if g and g.Parent then
            local c1=Color3.fromHSV(rainbowHue,0.8,1)
            local c2=Color3.fromHSV((rainbowHue+0.33)%1,0.8,1)
            local c3=Color3.fromHSV((rainbowHue+0.66)%1,0.8,1)
            g.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(0.5,c2),ColorSequenceKeypoint.new(1,c3)})
            g.Rotation=(g.Rotation+1.1)%360
        end
    end
end)

local function playClick()
    task.spawn(function()
        local s=Instance.new("Sound"); s.SoundId="rbxassetid://94753039770005"
        s.Volume=1; s.Parent=Workspace; s:Play(); s.Ended:Wait(); s:Destroy() end)
end
local function animPress(btn)
    local ox,oy=btn.Size.X.Offset,btn.Size.Y.Offset
    TweenService:Create(btn,TweenInfo.new(0.07),{Size=UDim2.new(btn.Size.X.Scale,ox-3,btn.Size.Y.Scale,oy-3)}):Play()
    task.wait(0.07)
    TweenService:Create(btn,TweenInfo.new(0.1,Enum.EasingStyle.Back),{Size=UDim2.new(btn.Size.X.Scale,ox,btn.Size.Y.Scale,oy)}):Play()
end

-- ScreenGui
local ScreenGui=Instance.new("ScreenGui"); ScreenGui.Name="WAOSFinder"; ScreenGui.ResetOnSpawn=false
if gethui then ScreenGui.Parent=gethui()
elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui); ScreenGui.Parent=game.CoreGui
else ScreenGui.Parent=player:WaitForChild("PlayerGui") end

-- ================================================
-- MAIN FRAME — 30% transparente + imagen de fondo
-- ================================================
local MainFrame=Instance.new("Frame")
MainFrame.Size=UDim2.new(0,430,0,0)
MainFrame.Position=UDim2.new(0.5,-215,0.5,-240)
MainFrame.BackgroundColor3=BG_COLOR
MainFrame.BackgroundTransparency=0.30
MainFrame.BorderSizePixel=0; MainFrame.ClipsDescendants=true; MainFrame.Parent=ScreenGui
Instance.new("UICorner",MainFrame).CornerRadius=UDim.new(0,24)
TweenService:Create(MainFrame,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,430,0,480)}):Play()

-- Imagen de fondo
local BgImage=Instance.new("ImageLabel",MainFrame)
BgImage.Size=UDim2.new(1,0,1,0); BgImage.Position=UDim2.new(0,0,0,0)
BgImage.Image="rbxassetid://114934113648126"; BgImage.ScaleType=Enum.ScaleType.Crop
BgImage.ImageTransparency=0; BgImage.BackgroundTransparency=1; BgImage.ZIndex=0

-- Overlay semiopaco para legibilidad
local BgOverlay=Instance.new("Frame",MainFrame)
BgOverlay.Size=UDim2.new(1,0,1,0); BgOverlay.BackgroundColor3=Color3.fromRGB(0,0,0)
BgOverlay.BackgroundTransparency=0.42; BgOverlay.BorderSizePixel=0; BgOverlay.ZIndex=1

local MainStroke=Instance.new("UIStroke",MainFrame)
MainStroke.Thickness=3; MainStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
makeRainbow(MainStroke)

-- ================================================
-- HEADER
-- ================================================
local Header=Instance.new("Frame",MainFrame)
Header.Size=UDim2.new(1,0,0,54); Header.BackgroundColor3=Color3.fromRGB(5,5,15)
Header.BackgroundTransparency=0.20; Header.BorderSizePixel=0; Header.ZIndex=2
Instance.new("UICorner",Header).CornerRadius=UDim.new(0,0)
local HS=Instance.new("UIStroke",Header); HS.Thickness=1.2; makeRainbow(HS)

local Title=Instance.new("TextLabel",Header)
Title.Text="WAOS Finder"; Title.Font=Enum.Font.GothamBlack; Title.TextScaled=true
Title.TextColor3=WHITE; Title.TextXAlignment=Enum.TextXAlignment.Left
Title.Size=UDim2.new(0,190,0,30); Title.Position=UDim2.new(0,16,0.5,-15)
Title.BackgroundTransparency=1; Title.ZIndex=3
makeRainbow(Title)

local function makeHBtn(text,xOff,w,bgC)
    local b=Instance.new("TextButton",Header)
    b.Size=UDim2.new(0,w,0,28); b.Position=UDim2.new(1,xOff,0.5,-14)
    b.BackgroundColor3=bgC or CARD_COLOR; b.BackgroundTransparency=0.20
    b.Text=text; b.TextColor3=WHITE; b.Font=Enum.Font.GothamBold; b.TextSize=12
    b.BorderSizePixel=0; b.ZIndex=3
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    local bs=Instance.new("UIStroke",b); bs.Thickness=1; makeRainbow(bs)
    return b
end
local RefreshBtn=makeHBtn("🔄 Refresh",-218,72)
local SettingsBtn=makeHBtn("⚙ Settings",-140,72)
local CloseBtn=makeHBtn("−",-38,30,RED_COL)
CloseBtn.Font=Enum.Font.GothamBlack; CloseBtn.TextSize=18

-- LOG AREA
local LogScroll=Instance.new("ScrollingFrame",MainFrame)
LogScroll.Size=UDim2.new(1,-20,1,-70); LogScroll.Position=UDim2.new(0,10,0,62)
LogScroll.BackgroundTransparency=1; LogScroll.ScrollBarThickness=4
LogScroll.ScrollBarImageColor3=Color3.fromRGB(180,0,255)
LogScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; LogScroll.ZIndex=2
Instance.new("UIListLayout",LogScroll).Padding=UDim.new(0,8)

local NoResults=Instance.new("TextLabel",LogScroll)
NoResults.Size=UDim2.new(1,0,0,60); NoResults.BackgroundTransparency=1
NoResults.Text="Esperando logs del bot..."; NoResults.TextColor3=Color3.fromRGB(200,150,255)
NoResults.TextSize=15; NoResults.Font=Enum.Font.Gotham; NoResults.ZIndex=3

-- NEW LOG NOTIF
local NewLogNotif=Instance.new("Frame",MainFrame)
NewLogNotif.Size=UDim2.new(1,-20,0,36); NewLogNotif.Position=UDim2.new(0,10,0,62)
NewLogNotif.BackgroundColor3=Color3.fromRGB(80,0,160); NewLogNotif.BackgroundTransparency=0.1
NewLogNotif.BorderSizePixel=0; NewLogNotif.Visible=false; NewLogNotif.ZIndex=10
Instance.new("UICorner",NewLogNotif).CornerRadius=UDim.new(0,10)
makeRainbow(NewLogNotif)
local NewLogLbl=Instance.new("TextLabel",NewLogNotif)
NewLogLbl.Size=UDim2.new(1,0,1,0); NewLogLbl.BackgroundTransparency=1
NewLogLbl.Text="✨ NEW LOG"; NewLogLbl.TextColor3=WHITE
NewLogLbl.Font=Enum.Font.GothamBlack; NewLogLbl.TextSize=16; NewLogLbl.ZIndex=11

local newLogTimer=nil
local function showNewLog()
    if newLogTimer then task.cancel(newLogTimer) end
    NewLogNotif.Position=UDim2.new(0,10,0,48); NewLogNotif.Visible=true
    TweenService:Create(NewLogNotif,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0,10,0,62)}):Play()
    newLogTimer=task.delay(4,function()
        TweenService:Create(NewLogNotif,TweenInfo.new(0.2,Enum.EasingStyle.Quad),{Position=UDim2.new(0,10,0,48)}):Play()
        task.wait(0.2); NewLogNotif.Visible=false end)
end

-- DRAG
local dragging,dragStart,startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true;dragStart=i.Position;startPos=MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(i)
    if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d=i.Position-dragStart
        MainFrame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) end end)
UserInputService.InputEnded:Connect(function() dragging=false end)

-- MINI FRAME
local isMin=false
local MiniFrame=Instance.new("Frame",ScreenGui)
MiniFrame.Size=UDim2.new(0,240,0,38); MiniFrame.Position=UDim2.new(0.5,-120,0.05,0)
MiniFrame.BackgroundColor3=BG_COLOR; MiniFrame.BackgroundTransparency=0.2; MiniFrame.Visible=false
Instance.new("UICorner",MiniFrame).CornerRadius=UDim.new(1,0)
local MS2=Instance.new("UIStroke",MiniFrame); MS2.Thickness=2; makeRainbow(MS2)
local MT=Instance.new("TextLabel",MiniFrame); MT.Text="⚡ WAOS Finder"
MT.Font=Enum.Font.GothamBold; MT.TextColor3=WHITE; MT.TextSize=13; MT.BackgroundTransparency=1
MT.Size=UDim2.new(0.65,0,1,0); MT.Position=UDim2.new(0,14,0,0); MT.TextXAlignment=Enum.TextXAlignment.Left
makeRainbow(MT)
local MiniOpen=Instance.new("TextButton",MiniFrame)
MiniOpen.Size=UDim2.new(0,26,0,26); MiniOpen.Position=UDim2.new(1,-32,0.5,-13)
MiniOpen.BackgroundColor3=CARD_COLOR; MiniOpen.Text="+"; MiniOpen.TextColor3=WHITE
MiniOpen.Font=Enum.Font.GothamBold; MiniOpen.TextSize=14
Instance.new("UICorner",MiniOpen).CornerRadius=UDim.new(1,0)

CloseBtn.MouseButton1Click:Connect(function()
    playClick(); isMin=not isMin
    if isMin then
        CloseBtn.Text="+"
        TweenService:Create(MainFrame,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{Size=UDim2.new(0,430,0,54)}):Play()
        task.wait(0.3); MainFrame.Visible=false; MiniFrame.Visible=true
    else
        MainFrame.Visible=true; MiniFrame.Visible=false; CloseBtn.Text="−"
        TweenService:Create(MainFrame,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,430,0,480)}):Play()
    end
end)
MiniOpen.MouseButton1Click:Connect(function()
    playClick(); isMin=false; MiniFrame.Visible=false; MainFrame.Visible=true; CloseBtn.Text="−"
    TweenService:Create(MainFrame,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,430,0,480)}):Play()
end)

-- ================================================
-- SETTINGS GUI
-- ================================================
local SettingsFrame=Instance.new("Frame",MainFrame)
SettingsFrame.Size=UDim2.new(1,0,1,0); SettingsFrame.BackgroundColor3=Color3.fromRGB(6,6,16)
SettingsFrame.BackgroundTransparency=0.10; SettingsFrame.BorderSizePixel=0
SettingsFrame.Visible=false; SettingsFrame.ZIndex=20
Instance.new("UICorner",SettingsFrame).CornerRadius=UDim.new(0,24)

local SH=Instance.new("Frame",SettingsFrame); SH.Size=UDim2.new(1,0,0,50); SH.BackgroundTransparency=1; SH.ZIndex=21
local ST=Instance.new("TextLabel",SH); ST.Text="⚙ Settings"; ST.Font=Enum.Font.GothamBlack; ST.TextSize=18
ST.TextColor3=WHITE; ST.Size=UDim2.new(0.45,0,1,0); ST.Position=UDim2.new(0,20,0,0); ST.BackgroundTransparency=1; ST.ZIndex=21

local SDefBtn=Instance.new("TextButton",SH)
SDefBtn.Size=UDim2.new(0,72,0,28); SDefBtn.Position=UDim2.new(1,-118,0.5,-14)
SDefBtn.BackgroundColor3=Color3.fromRGB(40,40,65); SDefBtn.BackgroundTransparency=0.2
SDefBtn.Text="Default"; SDefBtn.TextColor3=WHITE; SDefBtn.Font=Enum.Font.GothamBold; SDefBtn.TextSize=12; SDefBtn.ZIndex=21
Instance.new("UICorner",SDefBtn).CornerRadius=UDim.new(0,8)
local SDS=Instance.new("UIStroke",SDefBtn); SDS.Thickness=1; makeRainbow(SDS)

local SXBtn=Instance.new("TextButton",SH)
SXBtn.Size=UDim2.new(0,30,0,30); SXBtn.Position=UDim2.new(1,-40,0.5,-15)
SXBtn.BackgroundColor3=RED_COL; SXBtn.Text="X"; SXBtn.TextColor3=WHITE
SXBtn.Font=Enum.Font.GothamBlack; SXBtn.TextSize=14; SXBtn.ZIndex=21
Instance.new("UICorner",SXBtn).CornerRadius=UDim.new(0,8)

local SScroll=Instance.new("ScrollingFrame",SettingsFrame)
SScroll.Size=UDim2.new(1,-20,1,-60); SScroll.Position=UDim2.new(0,10,0,55)
SScroll.BackgroundTransparency=1; SScroll.ScrollBarThickness=3
SScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y; SScroll.ZIndex=21
Instance.new("UIListLayout",SScroll).Padding=UDim.new(0,8)

local sRefs={}
local function makeSLabel(text,parent)
    local l=Instance.new("TextLabel",parent); l.Size=UDim2.new(1,0,0,20); l.BackgroundTransparency=1
    l.Text=text; l.TextColor3=Color3.fromRGB(200,160,255); l.Font=Enum.Font.GothamBlack; l.TextSize=11
    l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=22 end

local function makeNumRow(label,key,suffix,isInt,parent)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,44)
    row.BackgroundColor3=CARD_COLOR; row.BackgroundTransparency=0.20; row.BorderSizePixel=0; row.ZIndex=22
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local rs=Instance.new("UIStroke",row); rs.Thickness=1; makeRainbow(rs)
    local l=Instance.new("TextLabel",row); l.Size=UDim2.new(0.45,0,1,0); l.Position=UDim2.new(0,10,0,0)
    l.BackgroundTransparency=1; l.Text=label; l.TextColor3=WHITE; l.Font=Enum.Font.Gotham; l.TextSize=13
    l.TextXAlignment=Enum.TextXAlignment.Left; l.ZIndex=23
    local mBtn=Instance.new("TextButton",row); mBtn.Size=UDim2.new(0,28,0,28); mBtn.Position=UDim2.new(0.5,0,0.5,-14)
    mBtn.BackgroundColor3=Color3.fromRGB(40,40,65); mBtn.BackgroundTransparency=0.15
    mBtn.Text="−"; mBtn.TextColor3=WHITE; mBtn.Font=Enum.Font.GothamBold; mBtn.TextSize=16; mBtn.ZIndex=23
    Instance.new("UICorner",mBtn).CornerRadius=UDim.new(0,6)
    local vLbl=Instance.new("TextLabel",row); vLbl.Size=UDim2.new(0,60,1,0); vLbl.Position=UDim2.new(0.5,32,0,0)
    vLbl.BackgroundTransparency=1; vLbl.TextColor3=Color3.fromRGB(220,220,255)
    vLbl.Font=Enum.Font.GothamBold; vLbl.TextSize=14; vLbl.ZIndex=23
    local sLbl=Instance.new("TextLabel",row); sLbl.Size=UDim2.new(0,35,1,0); sLbl.Position=UDim2.new(0.5,94,0,0)
    sLbl.BackgroundTransparency=1; sLbl.Text=suffix; sLbl.TextColor3=Color3.fromRGB(140,140,170)
    sLbl.Font=Enum.Font.Gotham; sLbl.TextSize=12; sLbl.ZIndex=23
    local pBtn=Instance.new("TextButton",row); pBtn.Size=UDim2.new(0,28,0,28); pBtn.Position=UDim2.new(0.5,130,0.5,-14)
    pBtn.BackgroundColor3=Color3.fromRGB(40,40,65); pBtn.BackgroundTransparency=0.15
    pBtn.Text="+"; pBtn.TextColor3=WHITE; pBtn.Font=Enum.Font.GothamBold; pBtn.TextSize=16; pBtn.ZIndex=23
    Instance.new("UICorner",pBtn).CornerRadius=UDim.new(0,6)
    local function upd() vLbl.Text=isInt and tostring(math.floor(settings[key])) or string.format("%.2f",settings[key]) end; upd()
    local step=isInt and 1 or 0.05; local minV=isInt and 1 or 0.05
    mBtn.MouseButton1Click:Connect(function() animPress(mBtn); settings[key]=math.max(minV,settings[key]-step)
        if not isInt then settings[key]=math.floor(settings[key]*100+0.5)/100 end; upd(); saveSettings() end)
    pBtn.MouseButton1Click:Connect(function() animPress(pBtn); settings[key]=settings[key]+step
        if not isInt then settings[key]=math.floor(settings[key]*100+0.5)/100 end; upd(); saveSettings() end)
    sRefs[key]=upd end

local function makeTogRow(label,key,parent)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,44)
    row.BackgroundColor3=CARD_COLOR; row.BackgroundTransparency=0.20; row.BorderSizePixel=0; row.ZIndex=22
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local rs=Instance.new("UIStroke",row); rs.Thickness=1; makeRainbow(rs)
    local btn=Instance.new("TextButton",row); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1; btn.ZIndex=23
    local function upd()
        local on=settings[key]; btn.Text=label..": "..(on and "ON" or "OFF"); btn.Font=Enum.Font.GothamBold; btn.TextSize=14
        btn.TextColor3=on and Color3.fromRGB(100,255,160) or Color3.fromRGB(180,180,200)
        TweenService:Create(row,TweenInfo.new(0.2),{BackgroundColor3=on and Color3.fromRGB(0,55,30) or CARD_COLOR}):Play()
    end; upd()
    btn.MouseButton1Click:Connect(function() playClick(); settings[key]=not settings[key]; upd(); saveSettings() end)
    sRefs[key]=upd end

local function makeListBtn(label,parent)
    local row=Instance.new("Frame",parent); row.Size=UDim2.new(1,0,0,44)
    row.BackgroundColor3=CARD_COLOR; row.BackgroundTransparency=0.20; row.BorderSizePixel=0; row.ZIndex=22
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local rs=Instance.new("UIStroke",row); rs.Thickness=1; makeRainbow(rs)
    local btn=Instance.new("TextButton",row); btn.Size=UDim2.new(1,0,1,0); btn.BackgroundTransparency=1
    btn.Text=label; btn.Font=Enum.Font.GothamBold; btn.TextSize=14
    btn.TextColor3=Color3.fromRGB(200,180,255); btn.ZIndex=23
    return row,btn end

makeSLabel("FILTER VALUES",SScroll)
makeNumRow("Min Money:","minMoney","M/s",true,SScroll)
makeNumRow("Min Force:","minForce","M/s",true,SScroll)
makeNumRow("Force Timeout:","forceTimeout","s",true,SScroll)
makeNumRow("Force Click Speed:","forceSpeed","s",false,SScroll)
makeSLabel("AUTOMATION",SScroll)
makeTogRow("Auto Join","autoJoin",SScroll)
makeTogRow("Auto Force Join","autoForce",SScroll)
makeSLabel("LISTS",SScroll)
local _,BLBtn   = makeListBtn("🚫  Blacklist Pets  ▶",SScroll)
local _,AFLBtn  = makeListBtn("⚡  Auto Force List  ▶",SScroll)
local _,TLBtn   = makeListBtn("🎯  Target List  ▶",SScroll)

SXBtn.MouseButton1Click:Connect(function() playClick(); SettingsFrame.Visible=false end)
SDefBtn.MouseButton1Click:Connect(function()
    playClick(); settings.minMoney=1; settings.minForce=100; settings.forceTimeout=10; settings.forceSpeed=0.15
    settings.autoJoin=false; settings.autoForce=false
    for _,f in pairs(sRefs) do f() end; saveSettings() end)
SettingsBtn.MouseButton1Click:Connect(function() playClick(); animPress(SettingsBtn); SettingsFrame.Visible=true end)

-- ================================================
-- PANEL LATERAL
-- ================================================
local SidePanel=Instance.new("Frame",ScreenGui)
SidePanel.Size=UDim2.new(0,350,0,480); SidePanel.Position=UDim2.new(0,560,0.5,-240)
SidePanel.BackgroundColor3=BG_COLOR; SidePanel.BackgroundTransparency=0.10
SidePanel.BorderSizePixel=0; SidePanel.Visible=false
Instance.new("UICorner",SidePanel).CornerRadius=UDim.new(0,20)
local SPStr=Instance.new("UIStroke",SidePanel); SPStr.Thickness=2.5; makeRainbow(SPStr)

local SPH=Instance.new("Frame",SidePanel); SPH.Size=UDim2.new(1,0,0,50); SPH.BackgroundTransparency=1
local SPTitle=Instance.new("TextLabel",SPH); SPTitle.Font=Enum.Font.GothamBlack; SPTitle.TextSize=15
SPTitle.TextColor3=WHITE; SPTitle.Size=UDim2.new(0.72,0,1,0); SPTitle.Position=UDim2.new(0,14,0,0)
SPTitle.BackgroundTransparency=1; SPTitle.TextXAlignment=Enum.TextXAlignment.Left
local SPClose=Instance.new("TextButton",SPH); SPClose.Size=UDim2.new(0,30,0,30); SPClose.Position=UDim2.new(1,-38,0.5,-15)
SPClose.BackgroundColor3=RED_COL; SPClose.Text="X"; SPClose.TextColor3=WHITE
SPClose.Font=Enum.Font.GothamBlack; SPClose.TextSize=14
Instance.new("UICorner",SPClose).CornerRadius=UDim.new(0,8)

-- Tabs: God / Secret / OG
local TabFrame=Instance.new("Frame",SidePanel)
TabFrame.Size=UDim2.new(1,-20,0,36); TabFrame.Position=UDim2.new(0,10,0,52); TabFrame.BackgroundTransparency=1
local tabBtns={}; local currentTab="God"
local function makeTab(text,xOff,w)
    local b=Instance.new("TextButton",TabFrame); b.Size=UDim2.new(0,w,0,32); b.Position=UDim2.new(0,xOff,0,0)
    b.BackgroundColor3=Color3.fromRGB(30,30,50); b.BackgroundTransparency=0.2
    b.Text=text; b.TextColor3=WHITE; b.Font=Enum.Font.GothamBold; b.TextSize=13; b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,10)
    local ts=Instance.new("UIStroke",b); ts.Thickness=1; makeRainbow(ts)
    return b end
tabBtns["God"]    = makeTab("🔱 God",   0,   104)
tabBtns["Secret"] = makeTab("🔮 Secret",108, 104)
tabBtns["OG"]     = makeTab("⭐ OG",    216, 104)

-- Search
local SearchBox=Instance.new("TextBox",SidePanel)
SearchBox.Size=UDim2.new(1,-20,0,32); SearchBox.Position=UDim2.new(0,10,0,94)
SearchBox.BackgroundColor3=Color3.fromRGB(18,18,32); SearchBox.BackgroundTransparency=0.15
SearchBox.PlaceholderText="Search name..."; SearchBox.PlaceholderColor3=Color3.fromRGB(120,120,150)
SearchBox.Text=""; SearchBox.TextColor3=WHITE; SearchBox.Font=Enum.Font.Gotham; SearchBox.TextSize=13; SearchBox.BorderSizePixel=0
Instance.new("UICorner",SearchBox).CornerRadius=UDim.new(0,8)
local SBP=Instance.new("UIPadding",SearchBox); SBP.PaddingLeft=UDim.new(0,8)
local SBS=Instance.new("UIStroke",SearchBox); SBS.Thickness=1; makeRainbow(SBS)

-- Select All / Clear
local SelAllBtn=Instance.new("TextButton",SidePanel)
SelAllBtn.Size=UDim2.new(0.47,-5,0,34); SelAllBtn.Position=UDim2.new(0,10,0,132)
SelAllBtn.BackgroundColor3=WHITE; SelAllBtn.BackgroundTransparency=0
SelAllBtn.Text="Select All"; SelAllBtn.TextColor3=DARK_COL
SelAllBtn.Font=Enum.Font.GothamBlack; SelAllBtn.TextSize=14; SelAllBtn.BorderSizePixel=0
Instance.new("UICorner",SelAllBtn).CornerRadius=UDim.new(0,10)

local ClearBtn=Instance.new("TextButton",SidePanel)
ClearBtn.Size=UDim2.new(0.47,-5,0,34); ClearBtn.Position=UDim2.new(0.52,0,0,132)
ClearBtn.BackgroundColor3=Color3.fromRGB(35,35,58); ClearBtn.BackgroundTransparency=0.15
ClearBtn.Text="Clear"; ClearBtn.TextColor3=WHITE; ClearBtn.Font=Enum.Font.GothamBold; ClearBtn.TextSize=14; ClearBtn.BorderSizePixel=0
Instance.new("UICorner",ClearBtn).CornerRadius=UDim.new(0,10)
local CS=Instance.new("UIStroke",ClearBtn); CS.Thickness=1; makeRainbow(CS)

-- Configure Target M/s
local ConfigTargetBtn=Instance.new("TextButton",SidePanel)
ConfigTargetBtn.Size=UDim2.new(1,-20,0,30); ConfigTargetBtn.Position=UDim2.new(0,10,0,172)
ConfigTargetBtn.BackgroundColor3=Color3.fromRGB(22,22,42); ConfigTargetBtn.BackgroundTransparency=0.15
ConfigTargetBtn.Text="Configure Target M/s ▶"; ConfigTargetBtn.TextColor3=Color3.fromRGB(200,180,255)
ConfigTargetBtn.Font=Enum.Font.GothamBold; ConfigTargetBtn.TextSize=13
ConfigTargetBtn.BorderSizePixel=0; ConfigTargetBtn.Visible=false
Instance.new("UICorner",ConfigTargetBtn).CornerRadius=UDim.new(0,8)
local CTS=Instance.new("UIStroke",ConfigTargetBtn); CTS.Thickness=1; makeRainbow(CTS)

-- Grid scroll
local BrainrotScroll=Instance.new("ScrollingFrame",SidePanel)
BrainrotScroll.Size=UDim2.new(1,-20,1,-178); BrainrotScroll.Position=UDim2.new(0,10,0,172)
BrainrotScroll.BackgroundTransparency=1; BrainrotScroll.ScrollBarThickness=3
BrainrotScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
BrainrotScroll.ScrollBarImageColor3=Color3.fromRGB(150,0,255)
local BGrid=Instance.new("UIGridLayout",BrainrotScroll)
BGrid.CellSize=UDim2.new(0.47,0,0,42); BGrid.CellPadding=UDim2.new(0.04,0,0,6); BGrid.SortOrder=Enum.SortOrder.LayoutOrder
local BPad=Instance.new("UIPadding",BrainrotScroll); BPad.PaddingTop=UDim.new(0,4); BPad.PaddingBottom=UDim.new(0,8)

local currentPanelMode=nil; local brainrotBtns={}

local function getListKey()
    if currentPanelMode=="blacklist" then return "blacklist"
    elseif currentPanelMode=="autoforce" then return "autoForceList"
    else return "targetList" end end

local function isSelected(name)
    local list=settings[getListKey()]
    for _,n in ipairs(list) do if n==name then return true end end; return false end

local function toggleBrainrot(name)
    local key=getListKey(); local list=settings[key]
    for i,n in ipairs(list) do if n==name then table.remove(list,i); saveSettings(); return false end end
    table.insert(list,name); saveSettings(); return true end

local function updateBtnVisual(btn,name)
    if isSelected(name) then
        TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(100,0,210),BackgroundTransparency=0}):Play()
        btn.TextColor3=WHITE
    else
        TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(22,22,40),BackgroundTransparency=0.1}):Play()
        btn.TextColor3=Color3.fromRGB(210,210,220) end end

local function rebuildGrid(filter)
    filter=filter or ""; brainrotBtns={}
    for _,c in ipairs(BrainrotScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    local list=BRAINROT_CATEGORIES[currentTab] or {}
    for _,name in ipairs(list) do
        if filter=="" or name:lower():find(filter:lower(),1,true) then
            local btn=Instance.new("TextButton",BrainrotScroll)
            btn.BackgroundColor3=Color3.fromRGB(22,22,40); btn.BackgroundTransparency=0.10
            btn.Text=name; btn.TextColor3=Color3.fromRGB(210,210,220)
            btn.Font=Enum.Font.GothamBold; btn.TextSize=11; btn.BorderSizePixel=0; btn.TextWrapped=true
            Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
            local bS=Instance.new("UIStroke",btn); bS.Thickness=1; makeRainbow(bS)
            updateBtnVisual(btn,name)
            btn.MouseButton1Click:Connect(function() playClick(); animPress(btn); toggleBrainrot(name); updateBtnVisual(btn,name) end)
            brainrotBtns[name]=btn end end end

local function updateTabVisuals()
    for tab,btn in pairs(tabBtns) do
        if tab==currentTab then btn.BackgroundColor3=WHITE; btn.BackgroundTransparency=0; btn.TextColor3=DARK_COL
        else btn.BackgroundColor3=Color3.fromRGB(30,30,50); btn.BackgroundTransparency=0.2; btn.TextColor3=WHITE end end end

local function openPanel(mode,title)
    if currentPanelMode==mode then
        TweenService:Create(SidePanel,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{Position=UDim2.new(0,580,0.5,-240)}):Play()
        task.wait(0.25); SidePanel.Visible=false; currentPanelMode=nil; return end
    currentPanelMode=mode; SPTitle.Text=title
    ConfigTargetBtn.Visible=(mode=="target")
    if mode=="target" then
        BrainrotScroll.Position=UDim2.new(0,10,0,210); BrainrotScroll.Size=UDim2.new(1,-20,1,-218)
    else
        BrainrotScroll.Position=UDim2.new(0,10,0,172); BrainrotScroll.Size=UDim2.new(1,-20,1,-178) end
    currentTab="God"; updateTabVisuals(); SearchBox.Text=""; rebuildGrid()
    SidePanel.Position=UDim2.new(0,580,0.5,-240); SidePanel.Visible=true
    TweenService:Create(SidePanel,TweenInfo.new(0.35,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Position=UDim2.new(0,546,0.5,-240)}):Play()
end

local function closePanel()
    TweenService:Create(SidePanel,TweenInfo.new(0.25,Enum.EasingStyle.Quad),{Position=UDim2.new(0,580,0.5,-240)}):Play()
    task.wait(0.25); SidePanel.Visible=false; currentPanelMode=nil end

SPClose.MouseButton1Click:Connect(function() playClick(); closePanel() end)
BLBtn.MouseButton1Click:Connect(function() playClick(); openPanel("blacklist","🚫 Blacklist Pets") end)
AFLBtn.MouseButton1Click:Connect(function() playClick(); openPanel("autoforce","⚡ Auto Force List") end)
TLBtn.MouseButton1Click:Connect(function() playClick(); openPanel("target","🎯 Target List") end)

for tab,btn in pairs(tabBtns) do
    btn.MouseButton1Click:Connect(function() playClick(); currentTab=tab; updateTabVisuals(); rebuildGrid(SearchBox.Text) end) end
SearchBox:GetPropertyChangedSignal("Text"):Connect(function() rebuildGrid(SearchBox.Text) end)

SelAllBtn.MouseButton1Click:Connect(function()
    playClick(); animPress(SelAllBtn)
    local list=BRAINROT_CATEGORIES[currentTab] or {}; local key=getListKey()
    for _,name in ipairs(list) do
        local found=false
        for _,n in ipairs(settings[key]) do if n==name then found=true; break end end
        if not found then table.insert(settings[key],name) end end
    saveSettings(); rebuildGrid(SearchBox.Text) end)

ClearBtn.MouseButton1Click:Connect(function()
    playClick(); animPress(ClearBtn)
    local list=BRAINROT_CATEGORIES[currentTab] or {}; local key=getListKey(); local newList={}
    for _,n in ipairs(settings[key]) do
        local inTab=false
        for _,name in ipairs(list) do if n==name then inTab=true; break end end
        if not inTab then table.insert(newList,n) end end
    settings[key]=newList; saveSettings(); rebuildGrid(SearchBox.Text) end)

-- ================================================
-- FORCE JOIN
-- ================================================
local forceActive=false
local function doForceJoin(entry,fBtn)
    if not entry or not entry.jobId then return end
    forceActive=true
    if fBtn then TweenService:Create(fBtn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(100,0,200)}):Play(); fBtn.Text="FORCING" end
    local elapsed=0
    task.spawn(function()
        while forceActive and elapsed<settings.forceTimeout do
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,entry.jobId,player) end)
            elapsed+=settings.forceSpeed; task.wait(settings.forceSpeed) end
        forceActive=false
        if fBtn and fBtn.Parent then TweenService:Create(fBtn,TweenInfo.new(0.15),{BackgroundColor3=FORCE_COL}):Play(); fBtn.Text="FORCE" end end) end

local function isBlacklisted(n) for _,x in ipairs(settings.blacklist) do if x==n then return true end end; return false end
local function isInAFL(n) for _,x in ipairs(settings.autoForceList) do if x==n then return true end end; return false end
local function isInTL(n) for _,x in ipairs(settings.targetList) do if x==n then return true end end; return false end

-- ================================================
-- LOG ROW
-- ================================================
local function createHistoryRow(entry)
    if entry.value<(settings.minMoney*1e6) then return nil end
    local isOther=entry.jobId~=game.JobId
    local row=Instance.new("Frame",LogScroll); row.Size=UDim2.new(1,0,0,52)
    row.BackgroundColor3=isOther and Color3.fromRGB(12,12,26) or CARD_COLOR
    row.BackgroundTransparency=0.20; row.BorderSizePixel=0; row.ClipsDescendants=true; row.ZIndex=3
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local rs=Instance.new("UIStroke",row); rs.Thickness=1.2; makeRainbow(rs)

    local sh=Instance.new("Frame",row); sh.Size=UDim2.new(0,60,2,0); sh.Position=UDim2.new(-0.3,0,-0.5,0)
    sh.BackgroundColor3=WHITE; sh.BackgroundTransparency=0.82; sh.Rotation=30; sh.ZIndex=4
    local sg=Instance.new("UIGradient",sh)
    sg.Transparency=NumberSequence.new{NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.4,0.3),NumberSequenceKeypoint.new(1,1)}
    TweenService:Create(sh,TweenInfo.new(2.8,Enum.EasingStyle.Linear,Enum.EasingDirection.InOut,-1),{Position=UDim2.new(1.3,0,-0.5,0)}):Play()

    local nl=Instance.new("TextLabel",row); nl.Text=(entry.count or 1).."x "..entry.name
    nl.Size=UDim2.new(0.43,0,1,0); nl.Position=UDim2.new(0,10,0,0)
    nl.BackgroundTransparency=1; nl.TextColor3=WHITE; nl.TextSize=13
    nl.Font=Enum.Font.GothamBold; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.ZIndex=4

    local ms=entry.value>=1e9 and string.format("$%.2fB/s",entry.value/1e9) or string.format("$%.0fM/s",entry.value/1e6)
    local ml=Instance.new("TextLabel",row); ml.Text=ms; ml.Size=UDim2.new(0.23,0,1,0); ml.Position=UDim2.new(0.44,0,0,0)
    ml.BackgroundTransparency=1; ml.TextColor3=Color3.fromRGB(120,255,160); ml.TextSize=12
    ml.Font=Enum.Font.GothamBold; ml.TextXAlignment=Enum.TextXAlignment.Left; ml.ZIndex=4

    local jb=Instance.new("TextButton",row); jb.Size=UDim2.new(0,55,0,30); jb.Position=UDim2.new(1,-122,0.5,-15)
    jb.BackgroundColor3=JOIN_COL; jb.BackgroundTransparency=0.1
    jb.Text="JOIN"; jb.TextColor3=WHITE; jb.Font=Enum.Font.GothamBlack; jb.TextSize=12; jb.ZIndex=4
    Instance.new("UICorner",jb).CornerRadius=UDim.new(0,6)
    local js=Instance.new("UIStroke",jb); js.Thickness=1; makeRainbow(js)
    jb.MouseButton1Click:Connect(function()
        playClick(); animPress(jb); jb.Text="..."
        pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,entry.jobId,player) end)
        task.delay(2,function() if jb and jb.Parent then jb.Text="JOIN" end end) end)

    local fb=Instance.new("TextButton",row); fb.Size=UDim2.new(0,55,0,30); fb.Position=UDim2.new(1,-60,0.5,-15)
    fb.BackgroundColor3=FORCE_COL; fb.BackgroundTransparency=0.1
    fb.Text="FORCE"; fb.TextColor3=WHITE; fb.Font=Enum.Font.GothamBlack; fb.TextSize=11; fb.ZIndex=4
    Instance.new("UICorner",fb).CornerRadius=UDim.new(0,6)
    fb.MouseButton1Click:Connect(function() playClick(); animPress(fb); doForceJoin(entry,fb) end)

    if not isBlacklisted(entry.name) then
        if settings.autoJoin or isInTL(entry.name) then
            task.delay(0.3,function() pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId,entry.jobId,player) end) end) end
        if (settings.autoForce or isInAFL(entry.name)) and entry.value>=(settings.minForce*1e6) then
            TweenService:Create(fb,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(100,0,200)}):Play()
            task.delay(0.5,function() doForceJoin(entry,fb) end) end end

    row.BackgroundTransparency=1
    TweenService:Create(row,TweenInfo.new(0.3,Enum.EasingStyle.Quad),{BackgroundTransparency=0.20}):Play()
    return row end

-- SESSION
local sessionDiscoveries={}
local function addEntry(entry)
    if entry.timestamp and entry.timestamp<SESSION_START then return false end
    if entry.value<(settings.minMoney*1e6) then return false end
    local key=tostring(entry.jobId).."|"..entry.name.."|"..tostring(entry.value)
    for _,e in ipairs(sessionDiscoveries) do
        if tostring(e.jobId).."|"..e.name.."|"..tostring(e.value)==key then return false end end
    table.insert(sessionDiscoveries,entry); return true end

local function rebuildLog()
    for _,c in ipairs(LogScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    if #sessionDiscoveries==0 then NoResults.Visible=true; return end
    NoResults.Visible=false
    for i=#sessionDiscoveries,1,-1 do createHistoryRow(sessionDiscoveries[i]) end end

-- WEBSOCKET
task.spawn(function()
    while true do
        pcall(function()
            local ws
            if WebSocket and WebSocket.connect then ws=WebSocket.connect(WS_URL)
            elseif syn and syn.websocket and syn.websocket.connect then ws=syn.websocket.connect(WS_URL) end
            if ws then
                ws.OnMessage:Connect(function(msg)
                    pcall(function()
                        local data=HttpService:JSONDecode(msg)
                        if not data or data.type~="brainrot" then return end
                        local entry={timestamp=data.timestamp or os.time(),timestampStr=data.timestampStr or "",
                            jobId=data.jobId,name=data.name,value=data.value,count=data.count or 1}
                        local added=addEntry(entry)
                        if added then rebuildLog(); showNewLog() end
                        if data.others then
                            for _,br in ipairs(data.others) do
                                if br.name~=data.name then
                                    addEntry({timestamp=data.timestamp or os.time(),timestampStr="",
                                        jobId=data.jobId,name=br.name,value=br.value,count=br.count or 1}) end end end
                    end) end) end end)
        task.wait(10) end end)

RefreshBtn.MouseButton1Click:Connect(function() playClick(); animPress(RefreshBtn); rebuildLog() end)

print("✅ WAOS Finder v4 - Loaded OK")
