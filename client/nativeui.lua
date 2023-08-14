_menuPool = NativeUI.CreatePool()
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if _menuPool:IsAnyMenuOpen() then
            _menuPool:ProcessMenus()
        else
            Citizen.Wait(150) -- this small line
        end
    end
end)
hasheist = false
AddEventHandler('heists:talktoheistnpc', function(resourceName)
    if hasheist == false then
        openmenu()
        
    else
    Config.Function.Notify(locale("alreadydoingheist"))
    end
   end)

   function openmenu()
print("yas")
     mainmenu = NativeUI.CreateMenu(locale("heistmenu"), "")
    _menuPool:Add(mainmenu)
    _menuPool:RefreshIndex()
    _menuPool:MouseControlsEnabled(false)
    _menuPool:MouseEdgeEnabled(false)
    _menuPool:ControlDisablingEnabled(false)
    mainmenu:Visible(true)
    camps = _menuPool:AddSubMenu(mainmenu, locale("camps"), "")
    local easy = NativeUI.CreateItem(locale("easy"), "")
       local medium = NativeUI.CreateItem(locale("medium"), "DISABLED TILL FURTHER UPDATE")
       local hard = NativeUI.CreateItem(locale("hard"), "DISABLED TILL FURTHER UPDATE")
       medium:Enabled(false)
       hard:Enabled(false)
   camps.SubMenu:AddItem(easy)
   camps.SubMenu:AddItem(medium)
   camps.SubMenu:AddItem(hard)
   _menuPool:MouseControlsEnabled(false)
   _menuPool:MouseEdgeEnabled(false)

   easy.Activated = function(sender, index)
    print(IsPedArmed(PlayerPedId(),4 ))
    if IsPedArmed(PlayerPedId(),4 ) == false then
        Config.Function.Notify(locale("notarmed"))
       
    else
        startcamp(1) -- 1 = easy
    end
    end

 local police = NativeUI.CreateItem("Police-Stations", "DISABLED TILL FURTHER UPDATE")
  local gangs = NativeUI.CreateItem('Gang-Bases/Warehouses', "DISABLED TILL FURTHER UPDATE")
mainmenu:AddItem(police)
mainmenu:AddItem(gangs)
police:Enabled(false)
gangs:Enabled(false)

  
   end