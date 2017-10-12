local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")

local MM = Scene:derive("MainMenu")

function MM:new(sceneMgr)
	self.super(sceneMgr)
	self.button = Button(320, 240, 125, 125)
end

function MM:draw()
	love.graphics.clear(255, 80, 80)
	love.graphics.setColor(255, 255, 255)
	self.button:draw()
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Main Menu", 160, 50, 0 ,3)
end

return MM
