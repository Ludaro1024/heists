function getRandomCamp()
    local randomIndex = math.random(#Config.Camps)
    return Config.Camps[randomIndex]
end
function startcamp(difficulty)
    if difficulty == 1 then
        campcoords = getRandomCamp()
  
        blips =  AddBlipForCoord(campcoords.x, campcoords.y, campcoords.z)
        SetBlipSprite(blips, 84)
        SetBlipColour(blips, 1)
        SetBlipAsShortRange(blips, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Camp")
        EndTextCommandSetBlipName(blips)
        SetBlipRoute(blips, true)
        function onEnterc()
            print("enter the camp!")
            SpawnCampNPCS(campcoords, Config.CampSettings.easy.amount, Config.CampSettings.easy.range, Config.CampSettings.easy.weapon, Config.CampSettings.easy.npc)
        end
        local camp = lib.zones.box({
            coords = {campcoords.x, campcoords.y, campcoords.z},
            debug = false,
            inside = insidec,
            onEnter = onEnterc,
            onExit = onExitc,
            size = {Config.CampSettings.easy.range + 50, Config.CampSettings.easy.range + 50, Config.CampSettings.easy.range + 50}
        })
      
    end
end

function deletenpcsifexist()
    if peds ~= nil then
        for i = 1, #peds do
            if peds[i] then
            if DoesEntityExist(peds[i]) then
                DeletePed(peds[i].ped)
            end
        end
    end
    end
end
function SpawnCampNPCS(startPos, npcCount, maxDistance, weapons, npc)
    deletenpcsifexist()
    peds = {}
    for i = 1, npcCount do
        local spawnX = startPos.x + math.random(-maxDistance, maxDistance)
        local spawnY = startPos.y + math.random(-maxDistance, maxDistance)
        local spawnZ = startPos.z
    -- spawnX, spawnY, spawnZ = GetClosestRoad(startPos.x, startPos.y, startPos.z, 10, 1, true)

        local pedModel = GetHashKey(npc) -- Change this to the desired ped model hash
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Citizen.Wait(0)
        end
        local ped = CreatePed(4, pedModel, spawnX, spawnY, spawnZ, 0.0, true, true)
        print("creating ped")
        blip = AddBlipForEntity(ped)
        SetPedAsNoLongerNeeded(ped)
        print(weapons)
        GiveWeaponToPed(ped, GetHashKey(string.upper(weapons)), 1, true, true)
 FreezeEntityPosition(ped, false)	
			SetEntityInvincible(ped, false)


			SetPedSeeingRange(ped, 100.0)
			SetPedHearingRange(ped, 80.0)
			SetPedCombatAttributes(ped, 46, 1)
			SetPedFleeAttributes(ped, 0, 0)
			SetPedCombatRange(ped,2)
			SetPedRelationshipGroupHash(ped, GetHashKey(0x06C3F072))
			SetPedDiesInWater(npc, false)
			SetRelationshipBetweenGroups(5,GetHashKey("PLAYER"),GetHashKey("0x06C3F072"))
			SetRelationshipBetweenGroups(5,GetHashKey("0x06C3F072"),GetHashKey("PLAYER"))
            TaskCombatPed(npc, GetPlayerPed(-1), 0, 16)
        table.insert(peds, {ped = ped,blip = blip})
        
      end
      for k,v in pairs(peds) do 
        GiveWeaponToPed(v.ped, GetHashKey(string.upper(weapons)), 1, true, true)
      end
deadpeds = 0
      Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            for i = 1, #peds do
                if IsEntityDead(peds[i].ped) then
                    peds[i].dead = true
                    RemoveBlip(peds[i].blip)
                end
            end

            if IsEntityDead(PlayerPedId()) then
                RemoveBlip(blips)
                for i = 1, #peds do
                  DeletePed(peds[i].ped)
                  RemoveBlip(peds[i].blip)
                end
                Config.Function.Notify(locale("youfailed"))
                break
            end

            if AreAllPedsDead(peds) then
                print("all peds dead")
                RemoveBlip(blips)
                for i = 1, #peds do
                  DeletePed(peds[i].ped)
                end
                missionsuccess()
                break
            end
            Citizen.Wait(1000)
        end
    end) 
end

function AreAllPedsDead(peds)
    for i = 1, #peds do
        if not peds[i].dead then
            return false
        end
    end
    return true
end


function missionsuccess()
    Config.Function.Notify(locale("youdididitc"))
    reward()
    RemoveBlip(sblip)
end

function reward()
    local reward = math.random(Config.CampSettings.easy.min, Config.CampSettings.easy.max)
    Config.Function.Notify(locale("reward") .. reward .. " " .. locale("$"))
    TriggerServerEvent("ludaro_heists:reward", reward)
end

-- RegisterCommand('test', function(source, args, rawCommand)
--     startcamp(1)
-- end)

AddEventHandler('onResourceStop', function(resourceName)
    if heistnpcc ~= nil or DoesEntityExist(heistnpcc) then
     DeletePed(heistnpcc)
    end
   end)

