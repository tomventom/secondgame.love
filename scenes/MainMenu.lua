local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")
local Label = require("lib.ui.Label")
local TextField = require("lib.ui.TextField")
local U = require("lib.Utils")

local MM = Scene:derive("MainMenu")

function MM:new(sceneMgr)
	MM.super.new(self, sceneMgr)
	self.click = function(button) self:onClick(button) end
	
end

local entered = false

function MM:enter()
	MM.super.enter(self)
	if not entered then
		entered = true
		local sw = love.graphics.getWidth()
		local sh = love.graphics.getHeight()
	
		local startButton = Button(sw/2, sh/2 - 30, 140, 40, "Start")
		local exitButton = Button(sw/2, sh/2 + 30, 140, 40, "Exit")
		exitButton:setButtonColors({170, 50, 50, 220}, {220, 40, 40}, {255, 20, 20})

		local mmtext = Label(0, 20, sw, 40, "Main Menu")
		local tf = TextField(80, 60, 100, 60, "hello", U.color(0, 255, 0), "left")
		self.em:add(startButton)
		self.em:add(exitButton)
		self.em:add(mmtext)	
		self.em:add(tf)	
	end
	_G.events:hook("onButtonClick", self.click)
end

function MM:exit()
	_G.events:unhook("onButtonClick", self.click)
end

function MM:onClick(button)
	print("Button clicked: " .. button.text)
	if button.text == "Start" then
		self.sceneMgr:switch("Test")
	elseif button.text == "Exit" then
		love.event.quit()
	end
end

function MM:update(dt)
	self.super.update(self, dt)
	-- if Key:keyDown("space") then
	-- 	self.startButton:enabled(not self.startButton.interactible)
	-- end
end

function MM:draw()
	love.graphics.clear(80, 80, 160)
	self.super.draw(self)
end

return MM
