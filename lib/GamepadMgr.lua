local Class = require("lib.Class")
local Event = require("lib.Events")
local GPM = Class:derive("GamepadMgr")

local DEAD_ZONE = 0.1

local function hookLoveEvents(self)

	function love.joystickadded(joystick)
		local id = joystick:getID()
		assert(self.connectedSticks[id] == nil, "Joystick " .. id .. " already exists!")
		self.connectedSticks[id] = joystick
		self.isConnected[id] = true
		self.buttonMap[id] = {}
		self.event:invoke("controllerAdded", id)
	end

	function love.joystickremoved(joystick)
		local id = joystick:getID()
		self.connectedSticks[id] = nil
		self.isConnected[id] = false
		self.buttonMap[id] = nil
		self.event:invoke("controllerRemoved", id)
	end

	function love.gamepadpressed(joystick, button)
		local id = joystick:getID()
		self.buttonMap[id][button] = true
	end

	function love.gamepadreleased(joystick, button)
		local id = joystick:getID()
		self.buttonMap[id][button] = false
	end
end

function GPM:new(dbFiles, adEnabled)
	if dbFiles ~= nil then
		for i = 1, #dbFiles do
			love.joystick.loadGamepadMappings(dbFiles[i])
		end
	end

	self.event = Event()
	self.event:add("controllerAdded")
	self.event:add("controllerRemoved")

	-- if true, the left analog joystick will be converted to
	-- its corresponding dpad output
	self.adEnabled = adEnabled

	-- the currently connected joysticks
	self.connectedSticks = {}
	self.isConnected = {}

	-- maps a joystick id to a table of key values
	-- where the key is a button and the value is either true = justPressed,
	-- false = justReleased, nil = none
	self.buttonMap = {}

	hookLoveEvents(self)
end

function GPM:exists(joyID)
	return self.isConnected[joyID] ~= nil and self.isConnected[joyID]
end

function GPM:getStick(joyID)
	return self.connectedSticks[joyID]
end

-- returns true if the given button was pressed for the given joyID this frame
function GPM:buttonDown(joyID, button)
	if self.isConnected[joyID] == nil or self.isConnected[joyID] == false then return false
	else return self.buttonMap[joyID][button] == true
	end
end

-- returns true if the given button was released for the given joyID this frame
function GPM:buttonUp(joyID, button)
	if self.isConnected[joyID] == nil or self.isConnected[joyID] == false then return false
	else return self.buttonMap[joyID][button] == false
	end
end

-- return the instantaneous state of the requested button for the given joystick
function GPM:button(joyID, button)
	local stick = self.connectedSticks[joyID]
	if self.isConnected[joyID] == nil or self.isConnected[joyID] == false then return false end

	local isDown = stick:isGamepadDown(button)

	if self.adEnabled and not isDown then
		local xAxis = stick:getGamepadAxis("leftx")
		local yAxis = stick:getGamepadAxis("lefty")
		if button == "dpright" then
			isDown = xAxis > DEAD_ZONE
		elseif button == "dpleft" then
			isDown = xAxis < -DEAD_ZONE
		elseif button == "dpup" then
			isDown = yAxis < -DEAD_ZONE
		elseif button == "dpdown" then
			isDown = yAxis > DEAD_ZONE
		end
	end

	return isDown
end

function GPM:update(dt)
	for i = 1, #self.isConnected do
		if self.buttonMap[i] then
			for k,_ in pairs(self.buttonMap[i]) do
				self.buttonMap[i][k] = nil
			end
		end
	end
end

return GPM