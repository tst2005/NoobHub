--------------------
-- NoobHub
-- opensource multiplayer and network messaging for CoronaSDK, Moai, Gideros & LÖVE
--
-- Demo project
-- Pings itself and measures network latency
-- Be sure to call Noobhub:enterFrame in love.update() callback!
--------------------

local noobhub = require("noobhub")
local md5 = require "md5" -- FIXME ?

local latencies = {}
local hub = noobhub.new({ server = "46.4.76.236"; port = 1337; })
local txt = ''

hub:subscribe({
	channel = "ping-channel"
	callback = function(message)
		print("message received  = "..json.encode(message))

		if (message.action == "ping") then ----------------------------------
			print ("pong sent")
			hub:publish({
				message = {
					action = "pong",
					id = message.id,
					original_timestamp = message.timestamp,
					timestamp = love.timer.getTime()
				}
			})
		end ----------------------------------------------------------------

		if (message.action == "pong") then ----------------------------------
			print ("pong id "..message.id.." received on "..love.timer.getTime().."; summary:   latency=" .. (love.timer.getTime() - message.original_timestamp) )
			table.insert( latencies, ( (love.timer.getTime() - message.original_timestamp) ) )

			local sum = 0
			local count = 0
			for i,lat in ipairs(latencies) do
				sum = sum + lat
				count = count + 1
			end

			print("---------- "..count..') average =  '..(sum/count))
			txt = 'Ping time average =  '..((sum/count)*1000)..' ms'
		end ----------------------------------------------------------------

	end
})

local dtotal = 0   -- this keeps track of how much time has passed
function love.update(dt)
	hub:enterFrame(); -- making sure to give some CPU time to Noobhub
	dtotal = dtotal + dt
	if dtotal >= 3 then -- send ping every 3 seconds
		dtotal = dtotal - 3
		hub:publish({
			message = {
				action = "ping",
				id = md5( love.timer.getTime() .. math.random() ),
				timestamp = love.timer.getTime()
			}
		})
		print("ping sent")
	end
end

function love.draw()
	love.graphics.print(txt, 200, 300)
end

