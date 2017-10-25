local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")
local U = require("lib.Utils")

local Slider = Class:derive("Slider")

function Slider:new(x, y, w, h, id)
	self.pos = Vector2(x or 0, y or 0)
	self.w = w
	self.h = h
	self.id = id or ""

	-- relative to slider pos
	self.sliderPos = 0
	self.prevSliderPos = 0
	self.sliderXDelta = 0
	self.sliderWidth = 10

	self.value = 0
	self.movingSlider = false

	-- slider colors
	self.normal = U.color(255, 180, 180, 180)
	self.highlight = U.color(255, 180, 180, 255)
	self.pressed = U.color(255, 220, 220, 255)
	self.disabled = U.grey(128, 128)

	self.grooveColor = U.grey(128)
	self.color = self.normal
	self.interactible = true
	self.prevLeftClick = false
end

function Slider:getValue()
	return U.round(self.sliderPos * 100 / (self.w - self.sliderWidth))
end

function Slider:update(dt)
	if not self.interactible then return end
	local mx, my = love.mouse.getPosition()
	local leftClick = love.mouse.isDown(1)
	local inBounds = U.mouseInRect(self.pos.x + self.sliderPos + self.sliderWidth / 2, self.pos.y - self.h / 2 + 3, self.sliderWidth, self.h, mx, my)

	if inBounds and not leftClick then
		self.color = self.highlight
	elseif inBounds and leftClick then
		if not self.prevLeftClick then
			self.sliderXDelta = self.sliderPos - mx
			self.movingSlider = true
		end
	end

	if self.movingSlider and leftClick then
		self.color = self.pressed
		self.prevSliderPos = self.sliderPos

		self.sliderPos = mx + self.sliderXDelta
		if self.sliderPos > self.w - self.sliderWidth then
			self.sliderPos = self.w - self.sliderWidth
		elseif self.sliderPos < 0 then
			self.sliderPos = 0
		end
		if self.prevSliderPos ~= self.sliderPos then
			_G.events:invoke("onSliderChanged", self)
		end

	elseif self.movingSlider and not leftClick then
		self.movingSlider = false
		self.color = self.normal
	end
	self.prevLeftClick = leftClick
end

function Slider:draw()
	local r, g, b, a = love.graphics.getColor()

	love.graphics.setColor(self.grooveColor)
	love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.h / 2, self.w, 6, 4, 4)

	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.pos.x + self.sliderPos, self.pos.y - self.h + 3, self.sliderWidth, self.h, 4, 4)

	love.graphics.setColor(r, g, b, a)
end

return Slider
