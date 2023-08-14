

idontwantmyeyestobleed = false
function onEnter1(self)
    print("created npc?")
    npchash = GetHashKey(Config.Heistsnpc.npcmodel)
    RequestModel(npchash)
    while not HasModelLoaded(npchash) do
        Wait(1)
    end
       heistnpcc = CreatePed(4, npchash, Config.Heistsnpc.coords.x, Config.Heistsnpc.coords.y, Config.Heistsnpc.coords.z, Config.Heistsnpc.coords.w, false, true)
       FreezeEntityPosition(heistnpc, true)
        SetEntityInvincible(heistnpc, true)
        SetBlockingOfNonTemporaryEvents(heistnpc, true)
        SetPedDiesWhenInjured(heistnpc, false)
        SetPedCanPlayAmbientAnims(heistnpc, true)
        SetPedCanRagdollFromPlayerImpact(heistnpc, false)
        SetEntityCanBeDamaged(heistnpc, false)
   
end

function onExit1(self)
  DeletePed(heistnpc)
end
 
function inside1(self)
    ESX.Game.Utils.DrawText3D(vector3(Config.Heistsnpc.coords.x, Config.Heistsnpc.coords.y, Config.Heistsnpc.coords.z + 2), locale("abovenpc"))
    if IsControlJustReleased(0, 38) then
        TriggerEvent("heists:talktoheistnpc")
    end
end
 
local heistnpc = lib.zones.box({
    coords = {Config.Heistsnpc.coords.x, Config.Heistsnpc.coords.y, Config.Heistsnpc.coords.z},
    debug = false,
    inside = inside1,
    onEnter = onEnter1,
    onExit = onExit1,
    size = {Config.Heistsnpc.range, Config.Heistsnpc.range, Config.Heistsnpc.range}
})

AddEventHandler('onResourceStop', function(resourceName)
   if heistnpcc ~= nil or DoesEntityExist(heistnpcc) then
    DeletePed(heistnpcc)
   end
  end)
