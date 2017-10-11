local class = require("class")
local Vector2 = class:derive("Vector2")

function Vector2:new(x, y)
	self.x = x or 0
	self.y = y or 0
end

return Vector2