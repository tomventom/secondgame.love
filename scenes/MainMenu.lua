local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")

local MM = Scene:derive("MainMenu")

function MM:new(sceneMgr)
	self.super(sceneMgr)
	local sw = love.graphics.getWidth()
	local sh = love.graphics.getHeight()

	self.startButton = Button(sw/2, sh/2 - 30, 140, 40, "Start")
	self.exitButton = Button(sw/2, sh/2 + 30, 140, 40, "Exit")
	self.exitButton:setButtonColors({170, 50, 50, 220}, {220, 40, 40}, {255, 20, 20})

	self.click = function(button) self:onClick(button) end
end

function MM:enter()
	_G.events:hook("onButtonClick", self.click)
end

function MM:exit()
	_G.events:unhook("onButtonClick", self.click)
end

function MM:onClick(button)
	print("Button clicked: " .. button.label)
	if button == self.startButton then
		self.sceneMgr:switch("Test")
	elseif button == self.exitButton then
		love.event.quit()
	end
end

function MM:update(dt)
	if Key:keyDown("space") then
		self.startButton:enabled(not self.startButton.interactible)
	end
	self.startButton:update(dt)
	self.exitButton:update(dt)
end

function MM:draw()
	love.graphics.clear(80, 80, 160)
	self.startButton:draw()
	self.exitButton:draw()
	love.graphics.printf("Main Menu", 0, 50, love.graphics.getWidth(), "center")
end

return MM
