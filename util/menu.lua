local menu = {}

local input = require "util.input"
local pb_memory = require "util.pb_memory"
local bridge = require "util.bridge"

local YELLOW = GAME_NAME == "yellow"

local sliding = false

-- Private functions

local function getRow(menuType, scrolls)
	if (menuType and menuType == "settings") then
		menuType = menuType.."_row"
	else
		menuType = "row"
	end
	local row = pb_memory.value("menu", menuType)
	if (scrolls) then
		row = row + pb_memory.value("menu", "scroll_offset")
	end
	return row
end

local function setRow(desired, throttle, scrolls, menuType, loop)
	local currentRow = getRow(menuType, scrolls)
	--bridge.chat("in setRow("..desired..")")
	if (throttle == "accelerate") then
		if (sliding) then
			throttle = false
		else
			local dist = math.abs(desired - currentRow)
			if (dist < 15) then
				throttle = true
			else
				throttle = false
				sliding = true
			end
		end
	else
		sliding = false
	end
	return menu.balance(currentRow, desired, true, loop, throttle)
end

local function isCurrently(desired, menuType)
	if (menuType) then
		menuType = menuType.."_current"
	else
		menuType = "current"
	end
	return pb_memory.value("menu", menuType) == desired
end
menu.isCurrently = isCurrently

-- Menu

function menu.getCol()
	return pb_memory.value("menu", "column")
end

function menu.open(desired, atIndex, menuType)
	if (isCurrently(desired, menuType)) then
		return true
	end
	menu.select(atIndex, false, false, menuType)
	return false
end

function menu.select(option, throttle, scrolls, menuType, dontPress, loop)
	if (setRow(option, throttle, scrolls, menuType, loop)) then
		local delay = 1
		if (throttle) then
			delay = 2
		end
		if (not dontPress) then
			input.press("A", delay)
		end
		return true
	end
end

function menu.cancel(desired, menuType)
	if (not isCurrently(desired, menuType)) then
		return true
	end
	input.press("B")
	return false
end

-- Selections

function menu.balance(current, desired, inverted, looping, throttle)
	if (current == desired) then
		sliding = false
		return true
	end
	if (not throttle) then
		throttle = 0
	else
		throttle = 1
	end
	local goUp = current > desired == inverted
	if (looping and math.abs(current - desired) > math.floor(looping / 2)) then
		goUp = not goUp
	end
	if (goUp) then
		input.press("Up", throttle)
	else
		input.press("Down", throttle)
	end
	return false
end

function menu.sidle(current, desired, looping, throttle)
	if (current == desired) then
		return true
	end
	if (not throttle) then
		throttle = 0
	else
		throttle = 1
	end
	local goLeft = current > desired
	if (looping and math.abs(current - desired) > math.floor(looping / 2)) then
		goLeft = not goLeft
	end
	if (goLeft) then
		input.press("Left", throttle)
	else
		input.press("Right", throttle)
	end
	return false
end

function menu.setCol(desired)
	return menu.sidle(menu.getCol(), desired)
end

-- Options

function menu.setOption(name, desired)
	if (YELLOW) then
		local rowFor = {
			text_speed = 0,
			battle_animation = 1,
			battle_style = 2
		}
		local currentRow = pb_memory.raw(0x0D3D)
		if (menu.balance(currentRow, rowFor[name], true, false, true)) then
			input.press("Left")
		end
	else
		local rowFor = {
			text_speed = 3,
			battle_animation = 8,
			battle_style = 13
		}
		if (pb_memory.value("setting", name) == desired) then
			return true
		end
		if (setRow(rowFor[name], true, false, "settings")) then
			menu.setCol(desired)
		end
	end
	return false
end

-- Pause menu

function menu.isOpen()
	return pb_memory.value("game", "textbox") == 1 or pb_memory.value("menu", "current") == 24
end

function menu.close()
	if (pb_memory.value("game", "textbox") == 0 and pb_memory.value("menu", "main") < 8) then
		return true
	end
	input.press("B")
end

function menu.pause()
	if (pb_memory.value("game", "textbox") == 1) then
		local main = pb_memory.value("menu", "main")
		if (main > 2 and main ~= 64) then
			return true
		end
		input.press("B")
	else
		input.press("Start", 2)
	end
end

function menu.save()
	local row = pb_memory.value("menu", "row")
	local main = pb_memory.value("menu", "main")
	local column = menu.getCol()
	if (main == 128) then -- if the pause menu is pulled up
		if (column == 11) then
			menu.select(4, true)
		end
	elseif (main == 141) then -- if the save menu is pulled up
		menu.select(0, true)
	end
	local saved = pb_memory.value("game", "saved")
	if (saved == 28) then --TODO or saved == 192) then
		return true
	end
end
	
return menu
