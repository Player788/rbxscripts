local join = {}

join.Join = function(userId)

	local user_id = tostring(userId)--"459999513"
	local game_id = tostring(game.PlaceId)
	local http_request = (syn and syn.request) or (http and http.request) or http_request
	local start_tick = tick()
	local http_service = game:GetService("HttpService")

	local image_request = http_request({
		Url = "https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=".. user_id .. "&size=150x150&format=Png&isCircular=false"
	})

	local image_url = http_service:JSONDecode(image_request.Body).data[1].imageUrl

	local servers, cursor = {}

	local index = 0

	local data = http_request({
		Url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Desc&limit=100%s", game_id, cursor and "&cursor=" .. cursor or "")
	})
	data = http_service:JSONDecode(data.Body)
	index = index + 1
	cursor = data.nextPageCursor
	task.spawn(function()
		for _, server in pairs(data.data) do
			local server_data = {}
			for i = 1, #server.playerTokens do
				table.insert(server_data, {
					token = server.playerTokens[i],
					type = "AvatarHeadshot",
					size = "150x150",
					requestId = server.id
				})
			end
			local post_request = http_request({
				Url = "https://thumbnails.roblox.com/v1/batch",
				Method = "POST",
				Body = http_service:JSONEncode(server_data),
				Headers = {
					["Content-Type"] = "application/json"
				}
			})
			local post_data = http_service:JSONDecode(post_request.Body).data
			if not post_data then
				return
			end
			if post_data[index] then
				print("searching server " .. post_data[index].requestId .. "\n")
			end
			for _, v in next, post_data do
				if v.imageUrl == image_url then
					--warn("found server " .. v.requestId .. " in " .. math.floor(tick() - start_tick) .. " seconds\n")				--game:GetService("TeleportService"):TeleportToPlaceInstance(game_id, v.requestId)
					--break 
					join = {true, "Server found " .. v.requestId .. " in " .. math.floor(tick() - start_tick) .. " seconds\n", game:GetService("TeleportService"):TeleportToPlaceInstance(game_id, v.requestId)}
					--return {true, "Server found " .. v.requestId .. " in " .. math.floor(tick() - start_tick) .. " seconds\n", game:GetService("TeleportService"):TeleportToPlaceInstance(game_id, v.requestId)}
				end
			end
		end
		--warn("Server not found")
		join = {false, "Server not found"}
		--return {false, "Server not found"}
	end)
end
return join
