local menuOn = false

local keybindControls = {
	["F1"] = 289, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local keybindControl = keybindControls["F5"]
        if IsControlPressed(0, keybindControl) then
            menuOn = true
            SendNUIMessage({
                type = 'init',
                resourceName = GetCurrentResourceName()
            })
            SetCursorLocation(0.5, 0.5)
            SetNuiFocus(true, true)
            PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
            while menuOn == true do Citizen.Wait(100) end
            Citizen.Wait(100)
            while IsControlPressed(0, keybindControl) do Citizen.Wait(100) end
        end
    end
end)

RegisterNUICallback('closemenu', function(data, cb)
    menuOn = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroy'
    })
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    cb('ok')
end)


RegisterNUICallback('openmenu', function(data)
    menuOn = false
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = 'destroy'
    })
    PlaySoundFrontend(-1, "NAV", "HUD_AMMO_SHOP_SOUNDSET", 1)
    if data.id == 'phone' then
			 TriggerEvent("pNotify:SendNotification", {text = "Pokazano licencję na broń", type = "success", timeout = 1400, layout = "centerRight"})
				ExecuteCommand('bron')
				ExecuteCommand('sprawdzbron')
    elseif data.id == 'billing' then
				TriggerEvent("pNotify:SendNotification", {text = "Pokazano dowód", type = "success", timeout = 1400, layout = "centerRight"})
				ExecuteCommand('dowod')
				ExecuteCommand('sprawdzdowod')
    elseif data.id == 'dance' then
        TriggerEvent("dp:RecieveMenu")
    elseif data.id == 'id' then
        TriggerEvent("esx_givecarkeys:keys")
    elseif data.id == 'work' then
        TriggerEvent("RollWindow")
    elseif data.id == 'inventory' then
				ExecuteCommand('drzwi 5')
				TriggerEvent("openbagaj")
    end


end)

	--Window Opening Script

local windowup = true
RegisterNetEvent("RollWindow")
AddEventHandler('RollWindow', function()
    local playerPed = GetPlayerPed(-1)
    if IsPedInAnyVehicle(playerPed, false) then
        local playerCar = GetVehiclePedIsIn(playerPed, false)
		if ( GetPedInVehicleSeat( playerCar, -1 ) == playerPed ) then
            SetEntityAsMissionEntity( playerCar, true, true )

			if ( windowup ) then
				TriggerEvent("pNotify:SendNotification", {text = "Opuszczono szybke", type = "error", timeout = 1400, layout = "centerLeft"})
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 2, "carwdown", 1.0)
				Citizen.Wait(3200)
				RollDownWindow(playerCar, 0)
				RollDownWindow(playerCar, 1)
				windowup = false
			else
				TriggerEvent("pNotify:SendNotification", {text = "Podniesono szybke", type = "success", timeout = 1400, layout = "centerLeft"})
				TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 2, "carwup", 1.0)
				Citizen.Wait(2775)
				RollUpWindow(playerCar, 0)
				RollUpWindow(playerCar, 1)
				windowup = true
			end
		end
	end
end )

	-- Door Opening Script

RegisterCommand("drzwi",function(source, args)
	if args[1] == nil or args[1] == '' then
		TriggerEvent('chatMessage', "Kontrola drzwi pojazdu - /drzwi [n]", {200,0,0} , '\n 0 - Przednie lewe drzwi \n 1 - Przednie prawe drzwi \n 2 - Lewe tylnie drzwi \n 3 - Prawe tylnie drzwi \n 4 - Maska \n 5 - Bagażnik \n 6 - Bagażnik2')
		return
	end
	args[1] = tonumber(args[1])
	if GetVehicleDoorAngleRatio(GetVehiclePedIsIn(PlayerPedId()), args[1]) < .2 then
				if args[1] == 5 then
					TriggerEvent("pNotify:SendNotification", {text = "Otworzono bagażnik", type = "success", timeout = 1400, layout = "centerLeft"})
				elseif args[1] == 4 then
					TriggerEvent("pNotify:SendNotification", {text = "Otworzono maske", type = "success", timeout = 1400, layout = "centerLeft"})
				else
					TriggerEvent("pNotify:SendNotification", {text = "Otworzono drzwi "..args[1], type = "success", timeout = 1400, layout = "centerLeft"})
				end
			SetVehicleDoorOpen(GetVehiclePedIsIn(PlayerPedId()), args[1], false, false)
	end
	if GetVehicleDoorAngleRatio(GetVehiclePedIsIn(PlayerPedId()), args[1]) > .2 then
		if args[1] == 5 then
			TriggerEvent("pNotify:SendNotification", {text = "Zamknięto bagażnik", type = "error", timeout = 1400, layout = "centerLeft"})
		elseif args[1] == 4 then
			TriggerEvent("pNotify:SendNotification", {text = "Zamknięto maske", type = "error", timeout = 1400, layout = "centerLeft"})
		else
			TriggerEvent("pNotify:SendNotification", {text = "Zamknięto drzwi "..args[1], type = "error", timeout = 1400, layout = "centerLeft"})
		end
	SetVehicleDoorShut(GetVehiclePedIsIn(PlayerPedId()), args[1], false)
	end
end, false)
