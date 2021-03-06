Key = require("lib.Keyboard")
local GPM = require("lib.GamepadMgr")
local SM = require("lib.SceneMgr")
local Event = require("lib.Events")

local sm

local gpm = GPM({"assets/gamecontrollerdb.txt"})

function love.load()
	-- Love2D game settings
	love.graphics.setDefaultFilter("nearest", "nearest")

	local font = love.graphics.newFont("assets/KGBLANK.ttf", 21)
	love.graphics.setFont(font)

	_G.events = Event(false)

	Key:hookLoveEvents()

	gpm.event:hook("controllerAdded", onControllerAdded)
	gpm.event:hook("controllerRemoved", onControllerRemoved)

	sm = SM("scenes", {"MainMenu", "Test"})
	sm:switch("MainMenu")

end

function onControllerAdded(joyID)
	print("controller " .. joyID .. " added")
end

function onControllerRemoved(joyID)
	print("controller " .. joyID .. " removed")
end

function love.update(dt)
	if dt > 0.04 then return end

	-- mx, my = love.mouse.getPosition()

	if Key:keyDown(",") then
		sm:switch("MainMenu")
	elseif Key:keyDown(".") then
		sm:switch("Test")
	elseif Key:keyDown("escape") then
		love.event.quit()
	end

	sm:update(dt)
	Key:update(dt)
	gpm:update(dt)
end

function love.draw()
	sm:draw()
	-- love.graphics.print(mx .. " " .. my, mx + 10, my - 10, 0, .5, .5)
end
