local bridge = {}

local utils = require("util.utils")

local client = nil
local timeStopped = false
local testVal = 1

local function send(prefix, body)
	if (client) then
		local message = prefix
		if (body) then
			message = message..","..body
		end
		client:send(message..'\n')
		return true
	end
end

local function readln()
	if (client) then
		local s, status, partial = client:receive('*l')
		if status == "closed" then
			client = nil
			return nil
		end
		if s and s ~= '' then
			return s
		end
	end
end

-- Wrapper functions

function bridge.init()
	if (comm.socketServerGetIp()~=nil) then
		--comm.socketServerSend("starttimer\r\n")
		--print(tostring(comm.socketServerResponse()))
	else
		print("Socket not active!")
	end
end

function bridge.tweet(message) -- Two of the same tweet in a row will only send one
	--print('tweet::'..message)
	return send("tweet", message)
end

function bridge.pollForName()
	bridge.polling = true
	send("poll_name")
end

function bridge.chat(message, extra)
	if (extra) then
		print(message.." || "..extra)
	else
		print(message)
	end
	return send("msg", message)
end

function bridge.time(message)
	if (not timeStopped) then
		return send("time", message)
	end
end

function bridge.stats(message)
	return send("stats", message)
end

function bridge.command(command)
	if (comm.socketServerGetIp()~=nil) then
		comm.socketServerSend("starttimer\r\n")
	end
end

function bridge.comparisonTime()
	return send("livesplit_getcomparisontime")
end

function bridge.process()
	local response = readln()
	if (response) then
		-- print('>'..response)
		if (response:find("name:")) then
			return response:gsub("name:", "")
		else

		end
	end
end

function bridge.input(key)
	send("input", key)
end

function bridge.caught(name)
	if (name) then
		send("caught", name)
	end
end

function bridge.hp(curr, max)
	send("hp", curr..","..max)
end

function bridge.liveSplit()
	if (comm.socketServerGetIp()~=nil) then
		comm.socketServerSend("starttimer\r\n")
	end
end

function bridge.split(encounters, finished)
	if (comm.socketServerGetIp()~=nil) then
		comm.socketServerSend("split\r\n")
	end
	if (finished) then
		timeStopped = true
	end
	--send("split")
end

function bridge.encounter()
	send("encounter")
end

function bridge.reset()
	if (comm.socketServerGetIp()~=nil) then
		comm.socketServerSend("reset\r\n")
	end
	timeStopped = false
end

function bridge.close()
	if client then
		client:close()
		client = nil
	end
	print("Bridge closed")
end

return bridge
