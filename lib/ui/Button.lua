local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local Button = Class:derive("Button")

local function color(r, g, b, a)
	return {r, g or r, b or r, a or 255}
end

local function grey(level, a)
	return {level, level, level, a or 255}
end

local function mouseInBounds(self, mouseX, mouseY)
	return mouseX >= self.pos.x - self.w / 2 and
		mouseX <= self.pos.x + self.w / 2 and
		mouseY >= self.pos.y - self.h / 2 and
		mouseY <= self.pos.y + self.h / 2
end

function Button:new(x, y, w, h, label)
	self.pos = Vector2(x or 0, y or 0)
	self.w = w
	self.h = h
	self.label = label
	-- button colors
	self.normal = color(100, 190, 50, 180)
	self.highlight = color(100, 190, 50, 255)
	self.pressed = color(100, 255, 50, 255)
	self.disabled = grey(128, 128)
	-- text colors
	self.textNormal = color(255)
	self.textDisabled = grey(180, 255)

	self.textColor = self.textNormal
	self.color = self.normal
	self.prevLeftClick = false
	self.interactible = true
end

function Button:left(x)
	self.pos.x = x + self.w / 2
end

function Button:right(x)
	self.pos.x = x - self.w / 2
end

function Button:top(y)
	self.pos.y = y + self.h / 2
end

function Button:bottom(y)
	self.pos.y = y - self.h / 2
end

function Button:enabled(enable)
	self.interactible = enable
	if not enable then
		self.color = self.disabled
		self.textColor = self.textDisabled
	else
		self.textColor = self.textNormal
	end
end

function Button:update(dt)
	if not self.interactible then return end
	x, y = love.mouse.getPosition()
	local leftClick = love.mouse.isDown(1)
	local inBounds = mouseInBounds(self, x, y)

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

function Button:draw()
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setColor(self.color)
	love.graphics.rectangle("fill", self.pos.x - self.w / 2, self.pos.y - self.h / 2, self.w, self.h, 4, 4)
	love.graphics.setColor(r,g,b,a)

	local f = love.graphics.getFont()
	local fw = f:getWidth(self.label)
	local fh = f:getHeight()
	r,g,b,a = love.graphics.getColor()
	love.graphics.setColor(self.textColor)
	love.graphics.print(self.label, self.pos.x - fw / 2, self.pos.y - fh / 2)
	love.graphics.setColor(r,g,b,a)
end

return Button