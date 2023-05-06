if (GetResourceState("es_extended") == "started") then
    if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
        ESX = exports["es_extended"]:getSharedObject()
    else
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
    end
end


function debug(msg)
    if Config.Debug then
        if type(msg) == "table" then
            print(debug(ESX.DumpTable(msg)))
        else
            print("[Ludaro|Debug] : " .. tostring(msg))
        end
    end
end

_menuPool = NativeUI.CreatePool()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if _menuPool:IsAnyMenuOpen() then
            _menuPool:ProcessMenus()
        else
            Citizen.Wait(150)
        end
    end
end)

Citizen.CreateThread(function()
    -- Getting the object to interact with
    house = exports['bob74_ipl']:GetMichaelObject()

    -- Scuba gear in the garage
    house.Garage.Enable(house.Garage.scuba, false, true)

    -- Set the house to messy (after the family left)
    house.Style.Set(house.Style.moved)

    -- Set the bed to messy too
    house.Bed.Set(house.Bed.messy)

    -- Enable house's movie poster upstair
    house.Details.Enable(house.Details.moviePoster, true)

    -- Enable Fame or Shame poster in Tracey's rorm
    house.Details.Enable(house.Details.fameShamePoste, true)

    -- Enable spyglasses on house's bedroom shelf
    house.Details.Enable(house.Details.spyGlasses, true)

    -- Plane tickets on the shelf in the corridor
    house.Details.Enable(house.Details.planeTicket, true)

    -- Put burger shots bags and cup in the kitchen
    house.Details.Enable(house.Details.bugershot, true)

    RefreshInterior(house.interiorId)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if disabled then
            DisableAllControlActions(0)
            EnableControlAction(0, 1)
            EnableControlAction(0, 2)
            EnableControlAction(0, 4)
            EnableControlAction(0, 6)
            EnableControlAction(0, 10)
            EnableControlAction(0, 11)
            EnableControlAction(0, 18)
            DisableControlAction(0, 73)
            DisableControlAction(0, 0)
            DisplayRadar(false)
            
        elseif look then
            TaskLookAtEntity(PlayerPedId(), michael, -1, 2048, 3)
            SetFollowPedCamViewMode(4)
        else
            DisplayRadar(true)
            Citizen.Wait(250)
        end
    end
end)

function showsubtitle(text, time)

    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end


AddEventHandler('esx:onPlayerSpawn',function(xPlayer, isNew, skin)

    local entryy = lib.callback.await('LE:GETENTRY', false)

    if entryy == false then
            TriggerEvent("einreisey")
    end
end)

RegisterNetEvent('lockpickdoor', function()
    exports.ox_doorlock:pickClosestDoor()
end)
RegisterNetEvent('einreisey', function()
    TriggerEvent('canUseInventoryAndHotbar:toggle', false) 

    SetEntityInvincible(PlayerPedId(), true)
    disabled = true
    SetFollowPedCamViewMode(1)
    TriggerServerEvent("einreise:setroutingbucket")
   
    DoScreenFadeOut(500)
    Citizen.Wait(1000)
    SetEntityCoords(PlayerPedId(), -817.9851, 177.6085, 72.2224, false, false, false, true)
    SetEntityHeading(PlayerPedId(), 297.2635)
    Citizen.Wait(2000)

    local model = GetHashKey("player_zero")
    RequestModel(model)
    while (not HasModelLoaded(model)) do
        Wait(1)
    end
    michael = CreatePed(4, model, -800.1814, 171.6127, 72.8350, 20.9831, true, true)

    TaskStartScenarioAtPosition(michael, "PROP_HUMAN_SEAT_BENCH", -799.7200, 171.6127, 72.3350, 101.2082, -1, false, false)
    

    DoScreenFadeIn(500)
    local coords1 = vector3(-809.6415, 180.4140, 72.1532)
    local coords2 = vector3(-806.9873, 175.6329, 72.8429)
    local coords3 = vector3(-803.2589, 177.1828, 72.8415)
    TaskGoToCoordAnyMeans(PlayerPedId(), coords1, 1.0, 0, 0, 786603, 0xbf80000)
    while #(GetEntityCoords(PlayerPedId()) - coords1) >= 2.5 do
        Wait(1)
    end
    showsubtitle("Hey Kumpel! Du bist ja heile in Los Santos gelandet, komm her!", 5000)
    TaskGoToCoordAnyMeans(PlayerPedId(), coords2, 1.0, 0, 0, 786603, 0xbf80000)
    while #(GetEntityCoords(PlayerPedId()) - coords2) >= 1.5 do
        Wait(1)
    end
    TaskGoToCoordAnyMeans(PlayerPedId(), coords3, 1.0, 0, 0, 786603, 0xbf80000)
    while #(GetEntityCoords(PlayerPedId()) - coords3) >= 1.5 do
        Wait(1)
    end
    local coords4 = vector3(-802.0768, 171.4271, 72.3246)

    TaskStartScenarioAtPosition(PlayerPedId(), "PROP_HUMAN_SEAT_BENCH", coords4, 290.6729, -1, false, false)
    while #(GetEntityCoords(PlayerPedId()) - coords4) >= 0.3 do
        Wait(1)
    end
  

    showsubtitle("Wie gehts dir? Lange nichts gehört.. Was Verschlägt dich so Nach Los Santos?", 5000)
  
    -- html starz
    look = true

    mainmenu = NativeUI.CreateMenu('', '')

    _menuPool:Add(mainmenu)
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)

    local legal = NativeUI.CreateItem('~g~Der Legale Weg',
    'Du bist ganz Normal in Los Santos eingereist mit dem Flugzeug und hast dein Visum bestanden')
    local illegal = NativeUI.CreateItem('~r~Der Illegale Weg',
    'Du Hast dich von Alten Schulfreunden über die Grenze Schmuggeln lassen')
    -- local legal = _menuPool:AddSubMenu(mainmenu, "~g~Der Legale weg")
    -- local illegal = _menuPool:AddSubMenu(mainmenu, "~r~Der Illegale weg")
    mainmenu:AddItem(legal)
    mainmenu:AddItem(illegal)

    legal.Activated = function(sender, index)
        einreiseart = 0
     
        mainmenu:Visible(false)
        -- get to car
        
        showsubtitle("Ach die Schöne Landschaft? wie Wunderschön, wollen wir sie uns ein wenig ansehen?", 5000)
        continuecutscene()
    end


    illegal.Activated = function(sender, index)
        einreiseart = 1
        mainmenu:Visible(false)
        -- get to car
        showsubtitle("Du bist auch Wegen den Drogen hier? Na dann, Mein Boss hat gerade eben eine Lieferung bestätigt", 5000)
        Citizen.Wait(5000)
        showsubtitle("Du kommst doch bestimmt mit oder?", 5000)
        Citizen.Wait(5000)
        showsubtitle("Das dachte ich mir!", 5000)
        continuecutscene()
    end

    -- wenn frage zuende
  
    mainmenu.Controls.Back.Enabled = false
    mainmenu:DisEnableControls({ 0, 202 })
    if not _menuPool:IsAnyMenuOpen() then
    mainmenu:Visible(true)
    end


    -- disabled = false
  -- local background = Sprite.New('custommenunew', 'banner', 0, 0, 512, 128)
   -- mainmenu:SetBannerSprite(background, true)


    
end)


AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        resetstuff()
    end
end)

RegisterNetEvent('einreise:reset', function(einreisetyp)
resetstuff()
endeinreise()
if einreisetyp == tostring(0) then
    TriggerServerEvent("einreise:legal")
elseif einreisetyp == tostring(1) then
    TriggerServerEvent("einreise:illegal")
end
end)




function continuecutscene()
    local modell = GetHashKey("tailgater")
    RequestModel(modell)
    while (not HasModelLoaded(modell)) do
        Wait(1)
    end
    vehicle = CreateVehicle(modell, -810.4313, 187.9340, 72.4787, 112.2831, true, true)
    Citizen.Wait(200)
    ClearPedTasks(michael)
    TaskEnterVehicle(michael, vehicle, -1, -1, 1.0, 1, 0)
    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())
    look = false
    SetFollowPedCamViewMode(1)
    --TriggerServerEvent("einreise:resetroutingbucket")

    gotop(PlayerPedId(), vector3(-810.6014, 189.2974, 72.4787))
    SetEntityDrawOutline(vehicle, true)
    while #(GetEntityCoords(PlayerPedId()) - vector3(-810.6014, 189.2974, 72.4787)) >= 7 do Wait(1) end
    SetEntityDrawOutline(vehicle, false)
  TaskEnterVehicle(PlayerPedId(), vehicle, -1, 0, 1.0, 1, 0)

    while not IsPedInVehicle(PlayerPedId(), vehicle, true) do Wait(1) end
    SetVehicleRadioEnabled(vehicle, false)
    if einreiseart == 1 then
    showsubtitle("Wir haben noch ein wenig zeit.. ich zeig dir die Stadt!", 5000)
    end
    local hospital = vector3(-654.7981, 310.1002, 82.9626)
    local hospitalc1 = vector4(-676.9203, 268.4902, 99.4898, 1.1762)
    if einreiseart == 0 then
        -- 445
        SetDriverAbility(michael, 1.0)        -- values between 0.0 and 1.0 are allowed.
SetDriverAggressiveness(michael, 0.0) -- values between 0.0 and 1.0 are allowed.

-- Example 1
-- Give the player a wander driving task.
TaskVehicleDriveWander(michael, vehicle, 15.0, 56)

-- Example 2
-- Manually set/override the driving style (after giving the ped a driving task).
SetDriveTaskDrivingStyle(michael, 957)

-- Example 3
-- Drive to a location (far away).
TaskVehicleDriveToCoordLongrange(michael, vehicle, hospital, 15.0,957, 19.0)
    else
        -- Useful functions to make the ped perform better while driving.
SetDriverAbility(michael, 1.0)        -- values between 0.0 and 1.0 are allowed.
SetDriverAggressiveness(michael, 0.0) -- values between 0.0 and 1.0 are allowed.

-- Example 1
-- Give the player a wander driving task.
TaskVehicleDriveWander(michael, vehicle, 15.0, 56)

-- Example 2
-- Manually set/override the driving style (after giving the ped a driving task).
SetDriveTaskDrivingStyle(michael, 572)

-- Example 3
-- Drive to a location (far away).
TaskVehicleDriveToCoordLongrange(michael, vehicle, hospital, 15.0, 572, 19.0)
    end

        Citizen.Wait(8000)
        showsubtitle("Das ~r~Scheiß ~w~Tor! so ein mist! einfach Geduld haben.. *seufz*", 10000)
    
    while #(GetEntityCoords(PlayerPedId()) - hospital) >= 20 do   Wait(1) end
    -- cam one
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", hospitalc1.x, hospitalc1.y, hospitalc1.z, 0.00, 0.00, hospitalc1.w, 100.00, false, 0)
    SetCamActive(cam, true)
	RenderScriptCams(true, true, 6000, true, true)
    showsubtitle("Achja.. Dashier ist Unser Krankenhaus, Das schönste in ganz LS.", 5000)
Citizen.Wait(5000)
SetCamActive(cam, false)
		DestroyCam(cam,true)
		RenderScriptCams(false, false, 0, true, true)
    local pd = vector3(-570.3707, -156.7126, 38.0144)
    local pdc = vector4(-554.2122, -153.7125, 40.4978, 17.6289)
    local mp = vector3(232.8943, -857.0241, 29.7965)
    local mpc = vector4(245.1232, -817.6346, 106.6001, 153.2275)
    local dd = vector3(385.8059, -842.1901, 29.1958)
    local ddc = vector4(404.1629, -841.1320, 31.8392, 50.9439)
    local illpoint = vector3(1622.5515, 3566.0022, 35.1462)
    local illc = vector4(1678.4133, 3510.1658, 115.4372, 60.6992)
    drivetoc(pd, "Dashier ist das Rockford PD, das Neumodischste im Ganzen Staat!", 5000, pdc)
    drivetoc(mp, "Dashier ist der Meeting Point, der Mittelpunkt der Stadt!", 5000, mpc)
    drivetoc(dd, "Dashier ist der Digital-Den! hier Kannst du dir dein Mobiltelefon Kaufen!", 5000, ddc)
local endc = vector3(-477.5583, -810.4423, 30.5408)
    if einreiseart == 1 then
    drivetoc(endc, "Mein Boss hat gerade angerufen, ich darf da nur alleine hin, ich bring dich zur u-bahn", 5000, vector4(-489.7234, -675.0235, 43.7554, 180.4606))
    endeinreise()
--     showsubtitle("Das wars, ab um die drogen abzuholen!", 5000)
--     drivetoc(illpoint, "Wir sind hier. Ich schreibe ihm schon, er bringt uns die drogen", 5000, illc, true)
--     copvehicle = CreateVehicle(GetHashKey("police"), 1564.3334, 3690.8167, 34.3072, 289.9002, true, true)
--     local pmodel = GetHashKey("s_m_m_security_01")
--     RequestModel(pmodel)
--     while (not HasModelLoaded(pmodel)) do
--         Wait(1)
--     end
--  cop = CreatePedInsideVehicle(copvehicle, 4, pmodel, -1, true, true)
--  SetPedArmour(cop, 100)
-- SetPedAccuracy(cop, 25)
-- SetPedSeeingRange(cop, 100000000.0)
-- SetPedHearingRange(cop, 100000000.0)
--  SetPedFleeAttributes(cop, 0, 0)
--  SetPedCombatAttributes(cop, 46, 1)
--  SetPedCombatAbility(cop, 100)
--  SetPedCombatMovement(cop, 2)
--  SetPedCombatRange(cop, 2)
--  TaskVehicleChase(michael, true)

--     -- ped1 = 
--     -- ped2 = 
--     -- ped3 = 
    else
    drivetoc(endc, "Ich muss leider noch etwas erledigen, ich bring dich zur u-bahn", 5000, vector4(-489.7234, -675.0235, 43.7554, 180.4606))
    endeinreise()
    end
end

function endeinreise()
    ESX.ShowNotification("Du hast Erfolgreich die Einreise Bestanden")
    DoScreenFadeOut(500)
    Citizen.Wait(1000)
    ESX.ShowNotification("Viel Spaß in Los Santos!")
    SetEntityCoords(PlayerPedId(), -489.3810, -707.9307, 28.3524)
    DoScreenFadeIn(500)
    gotop(PlayerPedId(), vector3(-489.2788, -699.0605, 33.2424))
    seteinreisetype()
    resetstuff()
end
function seteinreisetype(type)
    if einreiseart == 0 then
TriggerServerEvent("einreise:legal")
    elseif einreiseart == 1 then
        TriggerServerEvent("einreise:illegal")
    end
end
function gotop(ped, coords)
    TaskGoToCoordAnyMeans(ped, coords, 1.0, 0, 0, 786603, 0xbf80000)
end

function resetstuff()
    TriggerServerEvent("einreise:resetroutingbucket")
    look = false
    TriggerEvent('canUseInventoryAndHotbar:toggle', true) 
    disabled = false
    if michael then
        DeletePed(michael)
    end
    if vehicle then
        ESX.Game.DeleteVehicle(vehicle)
    end
    if DoesCamExist(cam) then
		SetCamActive(cam, false)
		DestroyCam(cam,true)
		RenderScriptCams(false, false, 0, true, true)
	end
    ClearPedTasks(PlayerPedId())
    
end



function drivetoc(coords, txt, wait, camcoords1, speed)
    if einreiseart == 0 then
        if speed == nil or speed == false then
        SetDriverAbility(michael, 1.0)        -- values between 0.0 and 1.0 are allowed.
SetDriverAggressiveness(michael, 0.0) -- values between 0.0 and 1.0 are allowed.

-- Example 1
-- Give the player a wander driving task.
TaskVehicleDriveWander(michael, vehicle, 15.0, 445)

-- Example 2
-- Manually set/override the driving style (after giving the ped a driving task).
SetDriveTaskDrivingStyle(michael, 445)

-- Example 3
-- Drive to a location (far away).
TaskVehicleDriveToCoordLongrange(michael, vehicle, coords, 15.0,445, 19.0)
        else
            SetDriverAbility(michael, 1.0)        -- values between 0.0 and 1.0 are allowed.
            SetDriverAggressiveness(michael, 0.0) -- values between 0.0 and 1.0 are allowed.
            
            -- Example 1
            -- Give the player a wander driving task.
            TaskVehicleDriveWander(michael, vehicle, 40.0, 445)
            
            -- Example 2
            -- Manually set/override the driving style (after giving the ped a driving task).
            SetDriveTaskDrivingStyle(michael, 445)
            
            -- Example 3
            -- Drive to a location (far away).
            TaskVehicleDriveToCoordLongrange(michael, vehicle, coords, 30.0,445, 19.0)
        end
    else
        if speed == nil or speed == false then   -- Useful functions to make the ped perform better while driving.
SetDriverAbility(michael, 1.0)        -- values between 0.0 and 1.0 are allowed.
SetDriverAggressiveness(michael, 0.0) -- values between 0.0 and 1.0 are allowed.

-- Example 1
-- Give the player a wander driving task.
TaskVehicleDriveWander(michael, vehicle, 40.0, 572)

-- Example 2
-- Manually set/override the driving style (after giving the ped a driving task).
SetDriveTaskDrivingStyle(michael, 572)

-- Example 3
-- Drive to a location (far away).
TaskVehicleDriveToCoordLongrange(michael, vehicle, coords, 30.0,572, 19.0)
        else
            SetDriverAbility(michael, 1.0)        -- values between 0.0 and 1.0 are allowed.
SetDriverAggressiveness(michael, 0.0) -- values between 0.0 and 1.0 are allowed.

-- Example 1
-- Give the player a wander driving task.
TaskVehicleDriveWander(michael, vehicle, 40.0, 572)

-- Example 2
-- Manually set/override the driving style (after giving the ped a driving task).
SetDriveTaskDrivingStyle(michael, 572)

-- Example 3
-- Drive to a location (far away).
TaskVehicleDriveToCoordLongrange(michael, vehicle, coords, 30.0,572, 19.0)
        end
    end
    while #(GetEntityCoords(PlayerPedId()) - coords) >= 20 do   Wait(1) end
    PlaySoundFrontend(-1, "TIMER_STOP", "HUD_MINI_GAME_SOUNDSET", 1)
    if camcoords1 then
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", camcoords1.x, camcoords1.y, camcoords1.z, 0.00, 0.00, camcoords1.w, 100.00, false, 0)
        SetCamActive(cam, true)
	    RenderScriptCams(true, true, 6000, true, true)
        wait = wait + 2000
    end
    showsubtitle(txt, wait)
    Citizen.Wait(wait)
    SetCamActive(cam, false)
		DestroyCam(cam,true)
		RenderScriptCams(false, false, 0, true, true)
    
end


