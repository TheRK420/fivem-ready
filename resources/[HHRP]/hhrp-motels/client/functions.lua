local PlayerId        = GetPlayerServerId (PlayerId ())

function ClothingMenu(room)

    elements = {}

    table.insert(elements, {label = 'Avaliable Outfits', value = 'player_dressing'})
	table.insert(elements, {label = 'Remove Outfits', value = 'remove_cloth'})

    HHCore.UI.Menu.Open('default', GetCurrentResourceName(), 'room', {
		title    = 'Clothing Menu',
		align    = 'top-left',
		elements = elements
	}, function(data, menu)

		if data.current.value == 'player_dressing' then

			HHCore.TriggerServerCallback('pw-motels:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				HHCore.UI.Menu.Open('default', GetCurrentResourceName(), 'player_dressing', {
					title    = 'Room '..room .. ' - Avaliable Outfits',
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					TriggerEvent('skinchanger:getSkin', function(skin)
						HHCore.TriggerServerCallback('pw-motels:getPlayerOutfit', function(clothes)
							TriggerEvent('skinchanger:loadClothes', skin, clothes)
							TriggerEvent('HHCore_skin:setLastSkin', skin)

							TriggerEvent('skinchanger:getSkin', function(skin)
								TriggerServerEvent('HHCore_skin:save', skin)
							end)
						end, data2.current.value)
					end)
				end, function(data2, menu2)
					menu2.close()
				end)
			end)

		elseif data.current.value == 'remove_cloth' then

			HHCore.TriggerServerCallback('pw-motels:getPlayerDressing', function(dressing)
				local elements = {}

				for i=1, #dressing, 1 do
					table.insert(elements, {
						label = dressing[i],
						value = i
					})
				end

				HHCore.UI.Menu.Open('default', GetCurrentResourceName(), 'remove_cloth', {
					title    = 'Room '..room .. ' - Remove Outfits',
					align    = 'top-left',
					elements = elements
				}, function(data2, menu2)
					menu2.close()
					TriggerServerEvent('pw-motels:removeOutfit', data2.current.value)
					HHCore.ShowNotification(_U('removed_cloth'))
				end, function(data2, menu2)
					menu2.close()
				end)
			end)
		end

	end, function(data, menu)
		menu.close()
	end)

end


DrawText3D = function(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end
