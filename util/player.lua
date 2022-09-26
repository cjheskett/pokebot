local player = {}

local textbox = require "action.textbox"

local input = require "util.input"
local pb_memory = require "util.pb_memory"

local facingDirections = {Up=8, Right=1, Left=2, Down=4}

function player.isFacing(direction)
	return pb_memory.value("player", "facing") == facingDirections[direction]
end

function player.face(direction)
	if (player.isFacing(direction)) then
		return true
	end
	if (textbox.handle()) then
		input.press(direction, 0)
	end
end

function player.interact(direction)
	if (player.face(direction)) then
		input.press("A", 2)
		return true
	end
end

function player.isMoving()
	return pb_memory.value("player", "moving") ~= 0
end

function player.position()
	return pb_memory.value("player", "x"), pb_memory.value("player", "y")
end

return player
