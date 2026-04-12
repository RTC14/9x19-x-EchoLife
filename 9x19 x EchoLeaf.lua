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
    ["67"]="https://static.wikia.nocookie.net/stealabr/images/8/83/BOIIIIIII_SIX_SEVEN_%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82%F0%9F%98%82.png",
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

-- (todo el código de GUI Timer, GUI Principal, funciones, etc. es exactamente el mismo que tenías)

-- ... [Aquí va todo el código que ya tenías desde "pcall(function() if writefile then..." hasta la función "sendWebhook" inclusive] ...

-- ==================== GUARDAR PARA EL FINDER (CROSS-SERVER) ====================
local function saveToFile()
    if not getgenv().BrainrotDiscoveries then getgenv().BrainrotDiscoveries = {} end
    pcall(function()
        if writefile then
            writefile("BrainrotDiscoveries.json", HttpService:JSONEncode(getgenv().BrainrotDiscoveries))
        end
    end)
end

-- En el LOOP SCAN, dentro del if not notified[hash] then
                notified[hash] = true
                setStatus("● Found! "..getRangeLabel(top.value), getRangeColor(top.value))
                sendWebhook(top, grouped, ordered, game.JobId)

                -- Guardar para el Finder (funciona entre servidores)
                if not getgenv().BrainrotDiscoveries then getgenv().BrainrotDiscoveries = {} end
                for _, br in ipairs(ordered) do
                    table.insert(getgenv().BrainrotDiscoveries, {
                        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
                        jobId     = game.JobId,
                        name      = br.name,
                        value     = br.value,
                        count     = br.count or 1
                    })
                end
                if #getgenv().BrainrotDiscoveries > 100 then
                    table.remove(getgenv().BrainrotDiscoveries, 1)
                end
                saveToFile()
                -- ===========================================================================
