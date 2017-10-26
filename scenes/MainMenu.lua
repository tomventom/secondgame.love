local Scene = require("lib.Scene")
local Button = require("lib.ui.Button")
local Label = require("lib.ui.Label")
local Slider = require("lib.ui.Slider")
local TextField = require("lib.ui.TextField")
local U = require("lib.Utils")

local MM = Scene:derive("MainMenu")

function MM:new(sceneMgr)
	MM.super.new(self, sceneMgr)

	local sw = love.graphics.getWidth()
	local sh = love.graphics.getHeight()

	local startButton = Button(sw / 2, sh / 2 - 30, 140, 40, "Start")
	local exitButton = Button(sw / 2, sh / 2 + 30, 140, 40, "Exit")
	exitButton:setButtonColors({170, 50, 50, 220}, {220, 40, 40}, {255, 20, 20})

	local mmtext = Label(0, 20, sw, 40, "Main Menu")
	self.tf = TextField(sw / 2 - 50, 60, 100, 40, "hello", U.grey(196), "left")
	self.slider = Slider(sw / 2 - 100, 140, 200, 30, "volume")
	self.testSlider = Slider(20, 40, 30, 200, "test", true)
	self.label = Label(425, 125, 50, 40, "0", U.grey(255), "left")
	self.testLabel = Label(10, 25, 50, 40, "0", U.grey(255), "center")

	self.em:add(startButton)
	self.em:add(exitButton)
	self.em:add(mmtext)
	self.em:add(self.tf)
	self.em:add(self.slider)
	self.em:add(self.testSlider)
	self.em:add(self.label)
	self.em:add(self.testLabel)

	self.click = function(button) self:onClick(button) end
	self.sliderChanged = function(slider) self:onSliderChanged(slider) end

end

local entered = false

function MM:enter()
	MM.super.enter(self)
	_G.events:hook("onButtonClick", self.click)
	_G.events:hook("onSliderChanged", self.sliderChanged)
end

function MM:exit()
	MM.super.exit(self)
	_G.events:unhook("onButtonClick", self.click)
	_G.events:unhook("onSliderChanged", self.sliderChanged)
end

function MM:onSliderChanged(slider)
	if slider.id == "volume" then
		self.label.text = slider:getValue()
	elseif slider.id == "test" then
		self.testLabel.text = slider:getValue()
	end
end

function MM:onClick(button)
	print("Button clicked: " .. button.text)
	if button.text == "Start" then
		self.sceneMgr:switch("Test")
	elseif button.text == "Exit" then
		love.event.quit()
	end
end

local prevDown = false
function MM:update(dt)
	self.super.update(self, dt)
	-- if Key:keyDown("space") then
	-- 	self.startButton:enabled(not self.startButton.interactible)
	-- end

	-- mouse stuff
	local xPos, yPos = love.mouse.getPosition()
	local down = love.mouse.isDown(1)

	if down and not prevDown then
		if U.pointInRect({x = xPos, y = yPos}, self.tf:getRect()) then
			self.tf:setFocus(true)
		else
			self.tf:setFocus(false)
		end
	end

	prevDown = down

end

function MM:draw()
	love.graphics.clear(80, 80, 160)
	self.super.draw(self)
end

return MM
