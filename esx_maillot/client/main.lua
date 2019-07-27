----------------------------------------------------------------------
---------- esx_maillot mit en place par Duch' ( Cpt_Speedy )----------
----------------------------------------------------------------------

local Keys = {
	["ESC"] = 322, ["BACKSPACE"] = 177, ["E"] = 38, ["ENTER"] = 18,	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173
}

local menuIsShowed				  = false
local hasAlreadyEnteredMarker     = false
local lastZone                    = nil
local isInMaillotMarker 		  = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

function ShowMaillotListingMenu(data)
	

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'jaillisting',
			{
				title    = _U('maillot_center'),
				elements = {
				{label = _U('citizen_wear'), value = 'citizen_wear'},
				{label = _U('maillot_wear'), value = 'maillot_wear'},
			},
			},
			function(data, menu)
			local ped = GetPlayerPed(-1)
			menu.close()

			if data.current.value == 'citizen_wear' then
				
				ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jailSkin)
				TriggerEvent('skinchanger:loadSkin', skin)
				end)

			end

			if data.current.value == 'maillot_wear' then 

		TriggerEvent('skinchanger:getSkin', function(skin)
        
            if skin.sex == 0 then
					local clothesSkin = {
						['tshirt_1'] = 15, ['tshirt_2'] = 0,
						['torso_1'] = 15, ['torso_2'] = 0,
						['decals_1'] = 0, ['decals_2'] = 0,
						['arms'] = 15,
						['pants_1'] = 16, ['pants_2'] = math.random(11),
						['shoes_1'] = 16, ['shoes_2'] = 0,
						['chain_1'] = 0, ['chain_2'] = 0,
						['helmet_1'] = -1, ['helmet_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				else
					local clothesSkin = {
						['tshirt_1'] = 14, ['tshirt_2'] = 0,
						['torso_1'] = 18, ['torso_2'] = math.random(11),
						['decals_1'] = 0, ['decals_2'] = 0,
						['arms'] = 15,
						['pants_1'] = 16, ['pants_2'] = math.random(11),
						['shoes_1'] = 16, ['shoes_2'] = 0,
						['chain_1'] = 0, ['chain_2'] = 0,						
						['helmet_1'] = -1, ['helmet_2'] = 0
					}
					TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
				end

            local playerPed = GetPlayerPed(-1)
            SetPedArmour(playerPed, 0)
            ClearPedBloodDamage(playerPed)
            ResetPedVisibleDamage(playerPed)
            ClearPedLastWeaponDamage(playerPed)
            
        end)
			end


		end,
			function(data, menu)
				menu.close()
			end
		)

	
end

AddEventHandler('esx_maillot:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i=1, #Config.Zones, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		isInMaillotMarker  = false
		local currentZone = nil
		for i=1, #Config.Zones, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < Config.ZoneSize.x) then
				isInMaillotMarker  = true
				SetTextComponentFormat('STRING')
            	AddTextComponentString(_U('access_jail_center'))
            	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end
		end
		if isInMaillotMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end
		if not isInMaillotMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_maillot:hasExitedMarker')
		end
	end
end)



-- Menu Controls
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, Keys['E']) and isInMaillotMarker and not menuIsShowed then
			ShowMaillotListingMenu()
		end
	end
end)
