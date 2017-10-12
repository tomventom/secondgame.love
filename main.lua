
Key = require("lib.Keyboard")
local GPM = require("lib.GamepadMgr")
local SM = require("lib.SceneMgr")

local sm

local gpm = GPM({"assets/gamecontrollerdb.txt"})

function love.load()
	-- Love2D game settings
	love.graphics.setDefaultFilter("nearest", "nearest")

	local font = love.graphics.newFont("assets/font.ttf", 21)
	love.graphics.setFont(font)

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

	if Key:keyDown(",") then
		sm:switch("MainMenu")
	elseif Key:keyDown(".") then
		sm:switch("Test")
	end

	sm:update(dt)
	Key:update(dt)
	gpm:update(dt)
end

function love.draw()
	sm:draw()
end