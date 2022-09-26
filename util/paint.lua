local paint = {}

local pb_memory = require "util.pb_memory"
local player = require "util.player"

local inventory = require "storage.inventory"
local pokemon = require "storage.pokemon"

local encounters = 0

function elapsedTime()
	local secs = pb_memory.raw(0xDA44)
	if (secs < 10) then
		secs = "0"..secs
	end
	local mins = pb_memory.raw(0xDA43)
	if (mins < 10) then
		mins = "0"..mins
	end
	return pb_memory.raw(0xDA41)..":"..mins..":"..secs
end
paint.elapsedTime = elapsedTime

function paint.draw(currentMap)
	local px, py = player.position()
	--gui.text(0, 28, currentMap..": "..px.." "..py)
	gui.text(0, 0, elapsedTime())

	if (pb_memory.value("battle", "our_id") > 0) then
		local hp = pokemon.index(0, "hp")
		local hpStatus
		if (hp == 0) then
			hpStatus = "DEAD"
		elseif (hp <= math.ceil(pokemon.index(0, "max_hp") * 0.2)) then
			hpStatus = "RED"
		end
		if (hpStatus) then
			gui.text(120, 7, hpStatus)
		end
	end

	local nidx = pokemon.indexOf("nidoran", "nidorino", "nidoking")
	if (nidx ~= -1) then
		local att = pokemon.index(nidx, "attack")
		local def = pokemon.index(nidx, "defense")
		local spd = pokemon.index(nidx, "speed")
		local scl = pokemon.index(nidx, "special")
		--gui.text(100, 0, att.." "..def.." "..spd.." "..scl)
	end
	local enc = " encounter"
	if (encounters ~= 1) then
		enc = enc.."s"
	end
	gui.text(0, 116, pb_memory.value("battle", "critical"))
	gui.text(0, 134, pb_memory.value("player", "repel"))
	gui.text(0, 152, encounters..enc)
	return true
end

function paint.wildEncounters(count)
	encounters = count
end

function paint.reset()
	encounters = 0
end

return paint
