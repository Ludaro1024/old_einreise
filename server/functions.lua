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
            print(print(ESX.DumpTable(msg)))
        else
            print("[Ludaro|Debug] : " .. tostring(msg))
        end
    end
end


RegisterNetEvent("einreise:legal", function()

    local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute("UPDATE users SET entry = @entry  WHERE identifier = @identifier",
	{
        ['@entry'] = 0,
        ['@identifier'] = xPlayer.getIdentifier(),
	})
end)

RegisterCommand('einreise', function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() == "admin" then
        
        if args[1] and args[2] then
            if args[2] == tostring(0) or args[2] == tostring(1) then
            TriggerClientEvent("einreise:reset", args[1], args[2])
            else
                xPlayer.showNotification("Bitte einreise art (0 = legal 1 = illegal) angeben")
            end
        else
            xPlayer.showNotification("Bitte ID angeben")
        end
    else
        xPlayer.showNotification("Das darfst du nicht!")
    end
end)


RegisterNetEvent("einreise:illegal", function()
  local xPlayer = ESX.GetPlayerFromId(source)
  MySQL.Async.execute("UPDATE users SET entry = @entry  WHERE identifier = @identifier",
  {
    ['@entry'] = 1,
	['@identifier'] = xPlayer.getIdentifier(),
  })
end)

lib.callback.register('LE:GETENTRY', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local result = MySQL.scalar.await('SELECT entry FROM users WHERE identifier = ?', {xPlayer.getIdentifier()})
    if result == 0 or 1 then
        return true
    else
    return false
    end
end)

