---------------- CONFIG ----------------
local WEBHOOK_10M  = "https://discord.com/api/webhooks/1492689969276256289/1zD11M5xnP4tE5rLc0b8p-NBS57-j2dFUr7BFPDTz42wPTkBSqdzXrewzws-vp0LnJro"
local WEBHOOK_100M = "https://discord.com/api/webhooks/1492690356989460540/hQCMTe-SaPbrEWsfqJj-_tziHKjIP7k2auJbFEkqIO2Crs5Nw2-aXfyJkfCfLQqHIOFd"
local WEBHOOK_500M = "https://discord.com/api/webhooks/1492690806757396520/-oLtSJWwEw74wSH3RKX99Dlabj4crZiF4Ev4iUlxN4p62xZYd43ksobljntgqKLIniWG"
local WEBHOOK_1B   = "https://discord.com/api/webhooks/1492691237638115523/iqmLgclpSqSH4cgttmmL4VY7m7h0RobRmBIit3ZEdU1KVVbKBKJnoAYUVxLJcVISHvsF"
local FOOTER       = "Bot Server Discord Notifier"
local SCAN_DELAY   = 0.1
local HOP_TIME     = 30
----------------------------------------

local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local TeleportService  = game:GetService("TeleportService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local http_request = (request) or (http and http.request) or (syn and syn.request)
if not http_request then return end

local player       = Players.LocalPlayer
local placeId      = game.PlaceId
local currentJobId = game.JobId
local triedServers = {}
local attempts     = 0
local notified     = {}
local minimized    = false
local isHopping    = false
local hopFailed    = false
local hopPaused    = false

-- IMÁGENES
local BRAINROT_IMAGES = {
    ["Arcadopus"]="https://www.lolga.com/uploads/images/goods/steal-a-brainrot/all-server-arcadopus.png",
    ["Mi Gatito"]="https://static.wikia.nocookie.net/stealabr/images/5/50/AyMiGatito.png",
    ["Bacuru and Egguru"]="https://static.wikia.nocookie.net/stealabr/images/b/b5/Bacuru_and_Egguru.png",
    ["Brunito Marsito"]="https://static.wikia.nocookie.net/stealabr/images/6/60/Brunito_Marsito_byLuiko.png",
    ["Burrito Bandito"]="https://static.wikia.nocookie.net/stealabr/images/e/e6/PoTaTo.png",
    ["Burguro And Fryuro"]="https://static.wikia.nocookie.net/stealabr/images/6/65/Burguro-And-Fryuro.png",
    ["Capitano Moby"]="https://static.wikia.nocookie.net/stealabr/images/e/ef/Moby.png",
    ["Cerberus"]="https://static.wikia.nocookie.net/stealabr/images/4/45/Cerberus.png",
    ["Chicleteira Bicicleteira"]="https://static.wikia.nocookie.net/stealabr/images/5/5a/Chicleteira.png",
    ["Chill Puppy"]="https://static.wikia.nocookie.net/stealabr/images/3/30/ChillPuppy.png",
    ["Chillin chili"]="https://static.wikia.nocookie.net/stealabr/images/e/e0/Chilin.png",
    ["Cooki and Milki"]="https://static.wikia.nocookie.net/stealabr/images/9/9b/Cooki_and_milki.png",
    ["Dragon Cannelloni"]="https://static.wikia.nocookie.net/stealabr/images/3/31/Nah_uh.png",
    ["Dragon Gingerini"]="https://static.wikia.nocookie.net/stealabr/images/3/3a/DragonGingerini.png",
    ["Eviledon"]="https://static.wikia.nocookie.net/stealabr/images/7/78/Eviledonn.png",
    ["Festive 67"]="https://static.wikia.nocookie.net/stealabr/images/c/c8/TransparentFestive67.png",
    ["Fragrama and Chocrama"]="https://static.wikia.nocookie.net/stealabr/images/9/9a/Fragrama_and_Chocrama.png",
    ["Garama and Madundung"]="https://static.wikia.nocookie.net/stealabr/images/e/ee/Garamadundung.png",
    ["Ginger Gerat"]="https://static.wikia.nocookie.net/stealabr/images/8/85/GingerGerat.png",
    ["Gobblino Uniciclino"]="https://static.wikia.nocookie.net/stealabr/images/c/c5/Gobblino_Uniciclino.png",
    ["Headless Horseman"]="https://static.wikia.nocookie.net/stealabr/images/f/ff/Headlesshorseman.png",
    ["Hydra Dragon Cannelloni"]="https://static.wikia.nocookie.net/stealabr/images/e/ee/Hydra_Dragon_Cannelloni.png",
    ["Jolly jolly Sahur"]="https://static.wikia.nocookie.net/stealabr/images/f/f1/JollyJollySahur.png",
    ["Ketupat Bros"]="https://static.wikia.nocookie.net/stealabr/images/4/4d/Ketupat_Bros.png",
    ["Ketupat Kepat"]="https://static.wikia.nocookie.net/stealabr/images/a/ac/KetupatKepat.png",
    ["Ketchuru and Musturu"]="https://static.wikia.nocookie.net/stealabr/images/1/14/Ketchuru.png",
    ["La Casa Boo"]="https://static.wikia.nocookie.net/stealabr/images/d/de/Casa_Booo.png",
    ["La Extinct Grande"]="https://static.wikia.nocookie.net/stealabr/images/c/cd/La_Extinct_Grande.png",
    ["La Grande Combinasion"]="https://static.wikia.nocookie.net/stealabr/images/d/d8/Carti.png",
    ["La Jolly Grande"]="https://static.wikia.nocookie.net/stealabr/images/5/5f/La_Chrismas_Grande.png",
    ["La Secret Combinasion"]="https://static.wikia.nocookie.net/stealabr/images/f/f2/Lasecretcombinasion.png",
    ["La Spooky Grande"]="https://static.wikia.nocookie.net/stealabr/images/5/51/Spooky_Grande.png",
    ["La Supreme Combinasion"]="https://static.wikia.nocookie.net/stealabr/images/5/52/SupremeCombinasion.png",
    ["La Taco Combinasion"]="https://static.wikia.nocookie.net/stealabr/images/8/84/Latacocombi.png",
    ["Las Sis"]="https://cdn.shopify.com/s/files/1/0837/8712/0919/files/Las_Sis_600x600.webp?v=1758288678",
    ["Lavadorito Spinito"]="https://static.wikia.nocookie.net/stealabr/images/f/ff/Lavadorito_Spinito.png",
    ["Los 25"]="https://static.wikia.nocookie.net/stealabr/images/9/9b/Transparent_Los_25.png",
    ["Los 67"]="https://static.wikia.nocookie.net/stealabr/images/d/db/Los-67.png",
    ["Los Bros"]="https://static.wikia.nocookie.net/stealabr/images/5/53/BROOOOOOOO.png",
    ["Los Burritos"]="https://static.wikia.nocookie.net/stealabr/images/9/97/LosBurritos.png",
    ["Los Candies"]="https://static.wikia.nocookie.net/stealabr/images/f/f9/Candy%21.png",
    ["Los Spaghettis"]="https://static.wikitide.net/italianbrainrotwiki/c/cb/Los_spaggetis.webp",
    ["Los Tacoritas"]="https://static.wikia.nocookie.net/stealabr/images/4/40/My_kids_will_also_rob_you.png",
    ["Los Puggies"]="https://static.wikia.nocookie.net/stealabr/images/c/c8/LosPuggies2.png",
    ["Lovin Rose"]="https://static.wikia.nocookie.net/stealabr/images/a/ab/LovinRose.png",
    ["Love Love Bear"]="https://static.wikia.nocookie.net/stealabr/images/b/bf/Love_Love_Bear.png",
    ["La Romantic Grande"]="https://static.wikia.nocookie.net/stealabr/images/d/d2/LaRomanricGrande_LeakBySammy.png",
    ["Meowl"]="https://static.wikia.nocookie.net/stealabr/images/b/b8/Clear_background_clear_meowl_image.png",
    ["Money Money Puggy"]="https://static.wikia.nocookie.net/stealabr/images/0/09/Money_money_puggy.png",
    ["Money Money Reindeer"]="https://static.wikia.nocookie.net/stealabr/images/e/ec/MoneyMoneyReindeer.png",
    ["Nuclearo Dinossauro"]="https://static.wikia.nocookie.net/stealabr/images/c/c6/Nuclearo_Dinosauro.png",
    ["Noo my Candy"]="https://static.wikia.nocookie.net/stealabr/images/1/12/Noo_my_candy_transparent.png",
    ["Noo my Present"]="https://static.wikia.nocookie.net/stealabr/images/3/35/Noo_my_Present.png",
    ["Naughty Naughty"]="https://static.wikia.nocookie.net/stealabr/images/1/13/Sought_the_naught.png",
    ["Noo my Heart"]="https://static.wikia.nocookie.net/stealabr/images/7/75/NooMyLoveheart.png",
    ["Orcaledon"]="https://static.wikia.nocookie.net/stealabr/images/a/a6/Orcaledon.png",
    ["Popcuru and Fizzuru"]="https://static.wikia.nocookie.net/stealabr/images/a/a9/Popuru_and_Fizzuru.png",
    ["Quesadilla Vampiro"]="https://static.wikia.nocookie.net/stealabr/images/0/0e/VampiroQuesa.png",
    ["Quesadilla Crocodila"]="https://static.wikia.nocookie.net/stealabr/images/3/3f/QuesadillaCrocodilla.png",
    ["Rang Ring Bus"]="https://static.wikia.nocookie.net/stealabr/images/2/2b/RingRangBus2.png",
    ["Reinito Sleighito"]="https://static.wikia.nocookie.net/stealabr/images/2/27/Reinito.png",
    ["Rosetti Tualetti"]="https://static.wikia.nocookie.net/stealabr/images/f/f8/Rossetti_Tualetti.png",
    ["Rosey and Teddy"]="https://static.wikia.nocookie.net/stealabr/images/9/9b/Rosey_and_Teddy.png",
    ["Skibidi Toilet"]="https://static.wikia.nocookie.net/stealabr/images/3/34/Skibidi_toilet.png",
    ["Spinny Hammy"]="https://static.wikia.nocookie.net/stealabr/images/7/7d/SpinnyHammy.png",
    ["Spaghetti Tualetti"]="https://static.wikia.nocookie.net/stealabr/images/b/b8/Spaghettitualetti.png",
    ["Spooky and Pumpky"]="https://static.wikia.nocookie.net/stealabr/images/d/d6/Spookypumpky.png",
    ["Strawberry Elephant"]="https://static.wikia.nocookie.net/stealabr/images/5/58/Strawberryelephant.png",
    ["Swag Soda"]="https://static.wikia.nocookie.net/stealabr/images/9/9f/Swag_Soda.png",
    ["Swaggy Bros"]="https://static.wikia.nocookie.net/stealabr/images/8/85/Swaggy_Bros.png",
    ["Tacorita Bicicleta"]="https://static.wikia.nocookie.net/stealabr/images/0/0f/Gonna_rob_you_twin.png",
    ["Tang Tang Keletang"]="https://static.wikia.nocookie.net/stealabr/images/c/ce/TangTangVfx.png",
    ["Tictac Sahur"]="https://static.wikia.nocookie.net/stealabr/images/6/6f/Time_moving_slow.png",
    ["Tralaledon"]="https://static.wikia.nocookie.net/stealabr/images/7/79/Brr_Brr_Patapem.png",
    ["Tuff Toucan"]="https://static.wikia.nocookie.net/stealabr/images/3/3e/TuffToucan.png",
    ["W or L"]="https://static.wikia.nocookie.net/stealabr/images/2/28/Win_Or_Lose.png",
    ["67"]="https://static.wikia.nocookie.net/stealabr/images/8/83/BOIIIIIII_SIX_SEVEN_%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82.png",
    ["La Ginger Sekolah"]="https://static.wikia.nocookie.net/stealabr/images/1/14/Esok_Ginger.png",
    ["Mariachi Corazoni"]="https://static.wikia.nocookie.net/stealabr/images/5/5a/MariachiCora.png",
    ["Mieteteira Bicicleteira"]="https://static.wikia.nocookie.net/stealabr/images/8/86/Mieteteira_Bicicleteira.png",
    ["Fishino Clownino"]="https://static.wikia.nocookie.net/stealabr/images/d/d6/Fishino_Clownino.png",
    ["Esok Sekolah"]="https://static.wikia.nocookie.net/stealabr/images/2/2a/EsokSekolah2.png",
    ["Cupid Cupid Sahur"]="https://static.wikia.nocookie.net/stealabr/images/8/89/Cupid_Cupid_Sahur.png",
    ["Cupid Hotspot"]="https://static.wikia.nocookie.net/stealabr/images/1/1f/Pot_Cupid.png",
    ["Chicleteira Cupideira"]="https://static.wikia.nocookie.net/stealabr/images/6/6f/Chicleteira_Cupideira.png",
    ["Chicleteirina Bicicleteirina"]="https://static.wikia.nocookie.net/stealabr/images/a/aa/Chicliterita_bicicliterita.png",
    ["Chicleteira Noelteira"]="https://static.wikia.nocookie.net/stealabr/images/b/b3/Noel.png",
    ["Chipso and Queso"]="https://static.wikia.nocookie.net/stealabr/images/f/f8/Chipsoqueso.png",
    ["Chimnino"]="https://static.wikia.nocookie.net/stealabr/images/c/c5/Chimnino.png",
    ["Celularcini Viciosini"]="https://media.discordapp.net/attachments/1452514638892634254/1459951125439713303/Celularcini_Viciosini.webp?format=png",
    ["DonkeyTurbo Express"]="https://static.wikia.nocookie.net/stealabr/images/9/9a/DonkeyturboExpress.png",
    ["Guest 666"]="https://static.wikia.nocookie.net/stealabr/images/9/99/Guest666t.png",
    ["Los Mi Gatitos"]="https://static.wikia.nocookie.net/stealabr/images/a/af/Los_ay_Gattitos.png",
    ["Los Hotspotsitos"]="https://static.wikia.nocookie.net/stealabr/images/6/69/Loshotspotsitos.png",
    ["Los Jolly Combinasionas"]="https://static.wikia.nocookie.net/stealabr/images/7/7b/Los_jollycombos.png",
    ["Los Mobilis"]="https://static.wikia.nocookie.net/stealabr/images/2/27/Losmobil.png",
    ["Los Planitos"]="https://static.wikia.nocookie.net/stealabr/images/8/83/Los_Planitos.png",
    ["Los Primos"]="https://static.wikia.nocookie.net/stealabr/images/9/96/LosPrimos.png",
    ["Los Quesadillas"]="https://static.wikia.nocookie.net/stealabr/images/9/99/LosQuesadillas.png",
    ["Los Spooky Combinasionas"]="https://static.wikia.nocookie.net/stealabr/images/8/8a/Lospookycombi.png",
    ["Los Chicleteiras"]="https://static.wikia.nocookie.net/stealabr/images/4/4d/Los_ditos.png",
    ["Los combinasionas"]="https://static.wikia.nocookie.net/stealabr/images/3/36/Stop_taking_my_chips_im_just_a_baybeh.png",
    ["Los nooo My Hotspotsitos"]="https://cdn.salla.sa/jDznl/003869f6-f451-47df-a720-491c012bfe01-1000x1000-X33W5yduW5d98TIEmdHhWHYgFwI9KCVCrqSIdZaF.png",
    ["Noo my Heart"]="https://static.wikia.nocookie.net/stealabr/images/7/75/NooMyLoveheart.png",
    ["Swag Soda"]="https://static.wikia.nocookie.net/stealabr/images/9/9f/Swag_Soda.png",
    ["Tang Tang Keletang"]="https://static.wikia.nocookie.net/stealabr/images/c/ce/TangTangVfx.png",
    ["Popcuru and Fizzuru"]="https://static.wikia.nocookie.net/stealabr/images/a/a9/Popuru_and_Fizzuru.png",
}

-- MUTACIONES conocidas
local MUTATIONS = {
    ["x2"] = true, ["x4"] = true, ["x8"] = true,
    ["x16"] = true, ["x32"] = true, ["x64"] = true,
    ["Bloodmoon"] = true, ["Golden"] = true,
    ["Rainbow"] = true, ["Shadow"] = true,
    ["Crystal"] = true, ["Neon"] = true,
}

pcall(function()
    if writefile then
        local ok, _ = pcall(readfile, "autoexec/bot_notifier.lua")
        if not ok then
            writefile("autoexec/bot_notifier.lua", "-- Bot Server Discord Notifier autoexec")
        end
    end
end)

------------------------------------------------
-- GUI CUENTA ATRAS
------------------------------------------------
local timerGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
timerGui.ResetOnSpawn = false
timerGui.Name = "BotTimer"

local timerFrame = Instance.new("Frame", timerGui)
timerFrame.Size = UDim2.new(0, 300, 0, 36)
timerFrame.Position = UDim2.new(0.5, -150, 0, 8)
timerFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 22)
timerFrame.BorderSizePixel = 0
Instance.new("UICorner", timerFrame).CornerRadius = UDim.new(0, 10)

local timerStroke = Instance.new("UIStroke", timerFrame)
timerStroke.Color = Color3.fromRGB(0, 210, 255)
timerStroke.Thickness = 1.5
timerStroke.Transparency = 0.4

local timerLabel = Instance.new("TextLabel", timerFrame)
timerLabel.Size = UDim2.new(0.72, 0, 1, 0)
timerLabel.Position = UDim2.new(0, 0, 0, 0)
timerLabel.BackgroundTransparency = 1
timerLabel.Text = "⏱ Hop in "..HOP_TIME.."s"
timerLabel.TextColor3 = Color3.fromRGB(0, 210, 255)
timerLabel.TextSize = 14
timerLabel.Font = Enum.Font.GothamBold

local pauseBtn = Instance.new("TextButton", timerFrame)
pauseBtn.Size = UDim2.new(0.26, -4, 0, 26)
pauseBtn.Position = UDim2.new(0.74, 0, 0.5, -13)
pauseBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
pauseBtn.Text = "⏸ Pausar"
pauseBtn.TextColor3 = Color3.new(1,1,1)
pauseBtn.TextSize = 12
pauseBtn.Font = Enum.Font.GothamBold
pauseBtn.BorderSizePixel = 0
Instance.new("UICorner", pauseBtn).CornerRadius = UDim.new(0, 6)

pauseBtn.MouseButton1Click:Connect(function()
    hopPaused = not hopPaused
    if hopPaused then
        pauseBtn.Text = "▶ Reanudar"
        pauseBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
        timerLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
        timerLabel.Text = "⏸ Pausado"
    else
        pauseBtn.Text = "⏸ Pausar"
        pauseBtn.BackgroundColor3 = Color3.fromRGB(255, 150, 0)
        timerLabel.TextColor3 = Color3.fromRGB(0, 210, 255)
    end
end)

------------------------------------------------
-- GUI PRINCIPAL
------------------------------------------------
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
gui.Name = "BotNotifier"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 360, 0, 0)
main.Position = UDim2.new(0.5, -180, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(10, 12, 22)
main.BorderSizePixel = 0
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(0, 210, 255)
stroke.Thickness = 1.5
stroke.Transparency = 0.4

TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 360, 0, 420)
}):Play()

local topbar = Instance.new("Frame", main)
topbar.Size = UDim2.new(1, 0, 0, 52)
topbar.BackgroundTransparency = 1

local title = Instance.new("TextLabel", topbar)
title.Size = UDim2.new(0, 280, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.RichText = true
title.Text = '<b><font color="#00CFFF">Bot Server</font> <font color="#FFFFFF">Discord Notifier</font></b>'
title.TextSize = 17
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local minBtn = Instance.new("TextButton", topbar)
minBtn.Size = UDim2.new(0, 30, 0, 30)
minBtn.Position = UDim2.new(1, -42, 0.5, -15)
minBtn.BackgroundColor3 = Color3.fromRGB(25, 30, 48)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.TextSize = 18
minBtn.Font = Enum.Font.GothamBold
minBtn.BorderSizePixel = 0
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 8)

local divider = Instance.new("Frame", main)
divider.Size = UDim2.new(1, -20, 0, 1)
divider.Position = UDim2.new(0, 10, 0, 52)
divider.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
divider.BackgroundTransparency = 0.6
divider.BorderSizePixel = 0

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, 0, 1, -53)
content.Position = UDim2.new(0, 0, 0, 53)
content.BackgroundTransparency = 1

local statusRow = Instance.new("Frame", content)
statusRow.Size = UDim2.new(1, -20, 0, 32)
statusRow.Position = UDim2.new(0, 10, 0, 10)
statusRow.BackgroundTransparency = 1

local statusDot = Instance.new("Frame", statusRow)
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(0, 0, 0.5, -5)
statusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 150)
statusDot.BorderSizePixel = 0
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusLabel = Instance.new("TextLabel", statusRow)
statusLabel.Size = UDim2.new(1, -15, 1, 0)
statusLabel.Position = UDim2.new(0, 18, 0, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "● Scanning..."
statusLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
statusLabel.TextSize = 14
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextXAlignment = Enum.TextXAlignment.Left

local rangesFrame = Instance.new("Frame", content)
rangesFrame.Size = UDim2.new(1, -20, 0, 32)
rangesFrame.Position = UDim2.new(0, 10, 0, 50)
rangesFrame.BackgroundTransparency = 1

local ranges = {
    { text = "10M-100M",  color = Color3.fromRGB(0, 200, 255) },
    { text = "100M-500M", color = Color3.fromRGB(0, 255, 150) },
    { text = "500M-1B",   color = Color3.fromRGB(255, 200, 0) },
    { text = "1B+",       color = Color3.fromRGB(255, 80, 80) },
}

for i, r in ipairs(ranges) do
    local tag = Instance.new("TextLabel", rangesFrame)
    tag.Size = UDim2.new(0.24, -4, 1, 0)
    tag.Position = UDim2.new((i-1)*0.25, 2, 0, 0)
    tag.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    tag.Text = r.text
    tag.TextColor3 = r.color
    tag.TextSize = 11
    tag.Font = Enum.Font.GothamBold
    tag.BorderSizePixel = 0
    Instance.new("UICorner", tag).CornerRadius = UDim.new(0, 6)
end

local resultsFrame = Instance.new("Frame", content)
resultsFrame.Size = UDim2.new(1, -20, 1, -160)
resultsFrame.Position = UDim2.new(0, 10, 0, 90)
resultsFrame.BackgroundColor3 = Color3.fromRGB(13, 16, 26)
resultsFrame.BorderSizePixel = 0
Instance.new("UICorner", resultsFrame).CornerRadius = UDim.new(0, 12)

local noResults = Instance.new("TextLabel", resultsFrame)
noResults.Size = UDim2.new(1, 0, 1, 0)
noResults.BackgroundTransparency = 1
noResults.Text = "Esperando brainrots..."
noResults.TextColor3 = Color3.fromRGB(90, 100, 135)
noResults.TextSize = 13
noResults.Font = Enum.Font.Gotham

local resultsList = Instance.new("ScrollingFrame", resultsFrame)
resultsList.Size = UDim2.new(1, -10, 1, -10)
resultsList.Position = UDim2.new(0, 5, 0, 5)
resultsList.BackgroundTransparency = 1
resultsList.ScrollBarThickness = 3
resultsList.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
resultsList.CanvasSize = UDim2.new(0, 0, 0, 0)
resultsList.Visible = false
Instance.new("UIListLayout", resultsList).Padding = UDim.new(0, 5)

local attemptsLabel = Instance.new("TextLabel", content)
attemptsLabel.Size = UDim2.new(1, -20, 0, 25)
attemptsLabel.Position = UDim2.new(0, 10, 1, -30)
attemptsLabel.BackgroundTransparency = 1
attemptsLabel.Text = "Servidores visitados: 0"
attemptsLabel.TextColor3 = Color3.fromRGB(80, 90, 120)
attemptsLabel.TextSize = 12
attemptsLabel.Font = Enum.Font.Gotham

-- DRAG
local dragging, dragStart, startPos
topbar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
       input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
       input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        content.Visible = false
        divider.Visible = false
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 360, 0, 52)
        }):Play()
        minBtn.Text = "+"
    else
        TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 360, 0, 420)
        }):Play()
        task.wait(0.35)
        content.Visible = true
        divider.Visible = true
        minBtn.Text = "−"
    end
end)

------------------------------------------------
-- FUNCIONES
------------------------------------------------
local function setStatus(text, color)
    statusLabel.Text = text
    statusLabel.TextColor3 = color
    statusDot.BackgroundColor3 = color
end

local function normalizeName(name)
    return name:lower():gsub("^%s+",""):gsub("%s+$",""):gsub("%s+"," ")
end

local function getBrainrotImage(name)
    for k, v in pairs(BRAINROT_IMAGES) do
        if normalizeName(k) == normalizeName(name) then
            return v
        end
    end
    return nil
end

local function getRangeColor(value)
    if value >= 1e9 then return Color3.fromRGB(255, 80, 80)
    elseif value >= 500e6 then return Color3.fromRGB(255, 200, 0)
    elseif value >= 100e6 then return Color3.fromRGB(0, 255, 150)
    else return Color3.fromRGB(0, 200, 255) end
end

local function getRangeLabel(value)
    if value >= 1e9 then return "1B+"
    elseif value >= 500e6 then return "500M-1B"
    elseif value >= 100e6 then return "100M-500M"
    else return "10M-100M" end
end

local function getRangeEmoji(value)
    if value >= 1e9 then return "🔴"
    elseif value >= 500e6 then return "🟡"
    elseif value >= 100e6 then return "🟢"
    else return "🔵" end
end

local function getWebhook(value)
    if value >= 1e9 then return WEBHOOK_1B
    elseif value >= 500e6 then return WEBHOOK_500M
    elseif value >= 100e6 then return WEBHOOK_100M
    else return WEBHOOK_10M end
end

local function formatMoney(v)
    if v >= 1e12 then return string.format("$%.2fT/s", v/1e12)
    elseif v >= 1e9 then return string.format("$%.2fB/s", v/1e9)
    else return string.format("$%.2fM/s", v/1e6) end
end

local function detectMutation(name)
    local lower = name:lower()
    if lower:find("x2") then return "x2 ⚡"
    elseif lower:find("x4") then return "x4 ⚡⚡"
    elseif lower:find("x8") then return "x8 ⚡⚡⚡"
    elseif lower:find("x16") then return "x16 💥"
    elseif lower:find("x32") then return "x32 💥💥"
    elseif lower:find("x64") then return "x64 💥💥💥"
    elseif lower:find("bloodmoon") or lower:find("blood") then return "🌑 Bloodmoon"
    elseif lower:find("golden") or lower:find("gold") then return "✨ Golden"
    elseif lower:find("rainbow") then return "🌈 Rainbow"
    elseif lower:find("shadow") then return "🌑 Shadow"
    elseif lower:find("crystal") then return "💎 Crystal"
    elseif lower:find("neon") then return "🌟 Neon"
    else return nil end
end

local function addResult(name, value)
    noResults.Visible = false
    resultsList.Visible = true

    local item = Instance.new("Frame", resultsList)
    item.Size = UDim2.new(1, 0, 0, 42)
    item.BackgroundColor3 = Color3.fromRGB(20, 24, 38)
    item.BorderSizePixel = 0
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 8)

    local rangeTag = Instance.new("TextLabel", item)
    rangeTag.Size = UDim2.new(0, 75, 0, 18)
    rangeTag.Position = UDim2.new(0, 8, 0, 4)
    rangeTag.BackgroundColor3 = Color3.fromRGB(10, 12, 22)
    rangeTag.Text = getRangeLabel(value)
    rangeTag.TextColor3 = getRangeColor(value)
    rangeTag.TextSize = 10
    rangeTag.Font = Enum.Font.GothamBold
    rangeTag.BorderSizePixel = 0
    Instance.new("UICorner", rangeTag).CornerRadius = UDim.new(0, 4)

    local nameL = Instance.new("TextLabel", item)
    nameL.Size = UDim2.new(0.6, 0, 0, 18)
    nameL.Position = UDim2.new(0, 8, 0, 22)
    nameL.BackgroundTransparency = 1
    nameL.Text = name
    nameL.TextColor3 = Color3.new(1,1,1)
    nameL.TextSize = 12
    nameL.Font = Enum.Font.GothamBold
    nameL.TextXAlignment = Enum.TextXAlignment.Left

    local valL = Instance.new("TextLabel", item)
    valL.Size = UDim2.new(0.35, 0, 1, 0)
    valL.Position = UDim2.new(0.62, 0, 0, 0)
    valL.BackgroundTransparency = 1
    valL.Text = value >= 1e9 and string.format("$%.2fB/s", value/1e9) or string.format("$%.0fM/s", value/1e6)
    valL.TextColor3 = getRangeColor(value)
    valL.TextSize = 13
    valL.Font = Enum.Font.GothamBold
    valL.TextXAlignment = Enum.TextXAlignment.Right

    resultsList.CanvasSize = UDim2.new(0, 0, 0, #resultsList:GetChildren() * 47)
end

local function clearResults()
    for _, c in ipairs(resultsList:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    resultsList.Visible = false
    noResults.Visible = true
    resultsList.CanvasSize = UDim2.new(0, 0, 0, 0)
end

local function parseProduction(text)
    local n, u = text:match("%$([%d%.]+)%s*([MBT])%s*/s")
    if not n then return end
    n = tonumber(n)
    if u == "M" then return n * 1e6 end
    if u == "B" then return n * 1e9 end
    if u == "T" then return n * 1e12 end
end

local function findServer()
    local cursor = ""
    while true do
        local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100&cursor="..cursor
        local success, result = pcall(function()
            return HttpService:JSONDecode(game:HttpGet(url))
        end)
        if success and result and result.data then
            for _, server in pairs(result.data) do
                if server.playing < server.maxPlayers
                and server.id ~= currentJobId
                and not triedServers[server.id] then
                    triedServers[server.id] = true
                    attempts += 1
                    attemptsLabel.Text = "Servidores visitados: "..attempts
                    return server.id
                end
            end
            if result.nextPageCursor then
                cursor = result.nextPageCursor
            else break end
        else break end
    end
    return nil
end

local function forceHop()
    if isHopping or hopPaused then return end
    isHopping = true
    clearResults()
    setStatus("● Hopping...", Color3.fromRGB(255, 200, 0))

    local serverId = findServer()

    if serverId then
        hopFailed = false
        timerLabel.Text = "⏱ Teleporting..."
        timerLabel.TextColor3 = Color3.fromRGB(0, 255, 150)
        pcall(function()
            if writefile then
                local ok, _ = pcall(readfile, "autoexec/bot_notifier.lua")
                if not ok then
                    writefile("autoexec/bot_notifier.lua", "-- Bot Server Discord Notifier autoexec")
                end
            end
        end)
        TeleportService:TeleportToPlaceInstance(placeId, serverId, player)
        triedServers = {}
    else
        hopFailed = true
        isHopping = false
    end
end

local function scan()
    local list = {}
    for _,ui in ipairs(workspace:GetDescendants()) do
        if ui:IsA("TextLabel") then
            local value = parseProduction(ui.Text)
            if value and value >= 10e6 then
                local parent = ui.Parent
                for _,c in ipairs(parent:GetChildren()) do
                    if c:IsA("TextLabel") and not c.Text:find("%$") then
                        table.insert(list, { name = c.Text, value = value })
                        break
                    end
                end
            end
        end
    end
    return list
end

local function sendWebhook(top, grouped, ordered, jobId)
    local webhook = getWebhook(top.value)
    local joinLink = "https://chillihub1.github.io/chillihub-joiner/?placeId="..placeId.."&gameInstanceId="..jobId

    local mutation = detectMutation(top.name)
    local img = getBrainrotImage(top.name)
    local rangeEmoji = getRangeEmoji(top.value)
    local rangeLabel = getRangeLabel(top.value)

    local description = ""
    description = description..rangeEmoji.." **Rango:** `"..rangeLabel.."`\n"
    description = description.."💰 **Producción:** `"..formatMoney(top.value).."`\n"

    if mutation then
        description = description.."⚡ **Mutación:** `"..mutation.."`\n"
    else
        description = description.."⚡ **Mutación:** `Sin mutación`\n"
    end

    local topCount = grouped[top.name] and grouped[top.name].count or 1
    description = description.."🔢 **Cantidad:** `"..topCount.."x`\n\n"

    description = description.."**📋 Join ID**\n```"..jobId.."```\n"
    description = description.."**🔗 Join Server**\n[**CLICK TO JOIN**]("..joinLink..")\n\n"

    if #ordered > 1 then
        description = description.."**🌟 Otros Brainrots Detectados:**\n```"
        for _, v in ipairs(ordered) do
            if normalizeName(v.name) ~= normalizeName(top.name) then
                local mut = detectMutation(v.name)
                local mutStr = mut and " ["..mut.."]" or ""
                description = description..v.count.."x "..v.name..mutStr.."\n"
                description = description.."   └ "..formatMoney(v.value).." | "..getRangeLabel(v.value).."\n"
            end
        end
        description = description.."```\n"
    end

    description = description.."**📊 Stats del Servidor**\n"
    description = description.."```"
    description = description.."Total brainrots: "..#ordered.."\n"
    description = description.."Server ID: "..jobId:sub(1,8).."...\n"
    description = description.."Servidores visitados: "..attempts
    description = description.."```"

    local color = 2829618
    if top.value >= 1e9 then color = 16711680
    elseif top.value >= 500e6 then color = 16763904
    elseif top.value >= 100e6 then color = 65430 end

    local titleEmoji = "💎"
    if mutation then
        if mutation:find("Bloodmoon") then titleEmoji = "🌑"
        elseif mutation:find("Golden") then titleEmoji = "✨"
        elseif mutation:find("Rainbow") then titleEmoji = "🌈"
        elseif mutation:find("x") then titleEmoji = "⚡"
        end
    end

    local embed = {
        title = titleEmoji.." **"..top.name.."**",
        description = description,
        color = color,
        footer = { text = FOOTER.." • "..os.date("%H:%M:%S") },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
    }

    if img then
        embed.thumbnail = { url = img }
    end

    http_request({
        Url = webhook,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({ embeds = { embed } })
    })
end

-- ✅ GUARDAR EN ARCHIVO (para compartir con el finder cross-server)
local function saveToFile()
    pcall(function()
        if writefile and getgenv().BrainrotDiscoveries then
            local data = HttpService:JSONEncode(getgenv().BrainrotDiscoveries)
            writefile("brainrot_history.json", data)
        end
    end)
end

------------------------------------------------
-- LOOP CUENTA ATRAS
------------------------------------------------
task.spawn(function()
    while true do
        if hopPaused then
            task.wait(0.5)
        elseif hopFailed then
            for i = 5, 0, -1 do
                if hopPaused then break end
                timerLabel.Text = "⚠️ Retry in "..i.."s"
                timerLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
                task.wait(1)
            end
            if not hopPaused then
                isHopping = false
                forceHop()
            end
        else
            for i = HOP_TIME, 0, -1 do
                if hopPaused then break end
                timerLabel.Text = "⏱ Hop in "..i.."s"
                timerLabel.TextColor3 = Color3.fromRGB(0, 210, 255)
                task.wait(1)
            end
            if not hopPaused then
                isHopping = false
                forceHop()
            end
        end
    end
end)

------------------------------------------------
-- LOOP SCAN
------------------------------------------------
task.spawn(function()
    while true do
        local list = scan()
        if #list > 0 then
            table.sort(list, function(a,b) return a.value > b.value end)
            clearResults()

            local grouped = {}
            for _,v in ipairs(list) do
                grouped[v.name] = grouped[v.name] or { name = v.name, value = v.value, count = 0 }
                grouped[v.name].count += 1
            end
            local ordered = {}
            for _,v in pairs(grouped) do table.insert(ordered, v) end
            table.sort(ordered, function(a,b) return a.value > b.value end)

            for _,v in ipairs(ordered) do
                addResult(v.count.."x "..v.name, v.value)
            end

            local top = list[1]
            local hash = normalizeName(top.name).."|"..math.floor(top.value).."|"..game.JobId
            if not notified[hash] then
                notified[hash] = true
                setStatus("● Found! "..getRangeLabel(top.value), getRangeColor(top.value))
                sendWebhook(top, grouped, ordered, game.JobId)

                -- ==================== GUARDAR PARA LA GUI =====================
                if not getgenv().BrainrotDiscoveries then
                    getgenv().BrainrotDiscoveries = {}
                end

                for _, br in ipairs(ordered) do
                    table.insert(getgenv().BrainrotDiscoveries, {
                        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
                        jobId = game.JobId,
                        name = br.name,
                        value = br.value,
                        count = br.count or 1
                    })
                end

                -- Mantener solo los últimos 100
                if #getgenv().BrainrotDiscoveries > 100 then
                    table.remove(getgenv().BrainrotDiscoveries, 1)
                end

                -- ✅ GUARDAR EN ARCHIVO PARA EL FINDER (CROSS-SERVER)
                saveToFile()
                -- ==============================================================
            end
        else
            if not hopPaused then
                setStatus("● Scanning...", Color3.fromRGB(0, 255, 150))
            else
                setStatus("● Pausado", Color3.fromRGB(150, 150, 150))
            end
        end
        task.wait(SCAN_DELAY)
    end
end)
