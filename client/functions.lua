if (GetResourceState("es_extended") == "started") then
    if (exports["es_extended"] and exports["es_extended"].getSharedObject) then
        ESX = exports["es_extended"]:getSharedObject()
    else
        TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
    end
end


function debug2(msg)
    if Config.Debug then
        local lineInfo = debug.getinfo(2, "Sl")
        local lineStr = ""
        if lineInfo then
            lineStr = " (" .. lineInfo.source .. ":" .. lineInfo.currentline .. ")"
        end

        if msg == nil then
            print("[Ludaro|Debug]" .. lineStr .. ": nil")
        elseif type(msg) == "table" then
            print("[Ludaro|Debug]" .. lineStr .. ":")
            print(ESX.DumpTable(msg))
        else
            print("[Ludaro|Debug]" .. lineStr .. ": " .. tostring(msg))
        end
    end
end

function locale(msg)
return Config.Translation[Config.Locale][msg]
end


if Config.Heistsnpc.blip.enabled == true then
    info = Config.Heistsnpc.blip
info.blip = AddBlipForCoord(Config.Heistsnpc.coords.x, Config.Heistsnpc.coords.y, Config.Heistsnpc.coords.z)
SetBlipSprite(info.blip, info.id)
SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 1.0)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
end

function DoesPedHaveShootingWeapon(ped)
    for i = 1, 7 do -- Iterate through weapon slots 1 to 7 (which are shooting weapons)
        local weaponHash = GetHashKey(GetWeapontypeModel(i))
        if HasPedGotWeapon(ped, weaponHash, false) then
            return true
        end
    end
    return false
end
