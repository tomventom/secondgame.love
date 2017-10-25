local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")
local U = require("lib.Utils")

local Slider = Class:derive("Slider")

function Slider:new(x, y, w, h)
	self.pos = Vector2(x or 0, y or 0)
	self.w = w
	self.h = h

    -- relative to slider pos
    self.sliderPos = 0
    self.value = 0

	-- slider colors
	self.normal = U.color(170, 170, 200, 255)
	self.highlight = U.color(155, 170, 180, 255)
	self.pressed = U.color(180, 190, 200, 255)
	self.disabled = U.grey(128, 128)

    self.color = self.normal
	-- self.interactible = true
    self.prevLeftClick = false
end

function Slider:update(dt)
    if not self.interactible then return end
	local mx, my = love.mouse.getPosition()
	local leftClick = love.mouse.isDown(1)
	local inBounds = U.mouseInRect(self.pos.x + self.sliderPos, self.pos.y, 20, self.h, mx, my)

    if inBounds and not leftClick then
		self.color = self.highlight
		if self.prevLeftClick then
			_G.events:invoke("onButtonClick", self)
		end
	elseif inBounds and leftClick then
		self.color = self.pressed
	else
		self.color = self.normal
	end

	self.prevLeftClick = leftClick
end

function Slider:draw()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.pos.x, self.pos.y - self.h / 2, self.w, 5, 4, 4)
	love.graphics.rectangle("fill", self.pos.x + self.sliderPos, self.pos.y - self.h, 10, self.h, 4, 4)

	love.graphics.setColor(r, g, b, a)
end

return Slider
