local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")

local MM = Scene:derive("MainMenu")

function MM:new(sceneMgr)
	self.super(sceneMgr)
	self.button = Button(320, 240, 160, 40, "Click Me")
end

function MM:enter()
	_G.events:hook("onButtonClick", onClick)
end

function MM:exit()
	_G.events:unhook("onButtonClick", onClick)
end

function onClick(button)
	print("Button clicked: " .. button.label)
end

function MM:update(dt)
	if Key:keyDown("space") then
		self.button:enabled(not self.button.interactible)
	end
	self.button:update(dt)
end

function MM:draw()
	love.graphics.clear(80, 80, 160)
	self.button:draw()
	love.graphics.print("Main Menu", 250, 50)
end

return MM
