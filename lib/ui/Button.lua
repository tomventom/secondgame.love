local Class = require("lib.Class")
local Vector2 = require("lib.Vector2")

local Button = Class:derive("Button")

function Button:new(x, y, w, h)
	self.pos = Vector2(x or 0, y or 0)
	self.w = w
	self.h = h
end

function Button:draw()
	love.graphics.rectangle("fill", self.pos.x - self.w / 2, self.pos.y - self.h / 2, self.w, self.h, 4, 4)
end

return Button