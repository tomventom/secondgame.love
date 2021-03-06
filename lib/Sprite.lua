local Class = require("lib.Class")
local Anim = require("lib.Animation")
local Vector2 = require("lib.Vector2")

local Sprite = Class:derive("Sprite")

function Sprite:new(atlas, x, y, w, h, sx, sy, angle, color)
	self.pos = Vector2(x or 0, y or 0)
	self.w = w
	self.h = h
	self.flip = Vector2(1, 1)
	self.scale = Vector2(sx or 1, sy or 1)
	self.atlas = atlas
	self.animations = {}
	self.currentAnim = ""
	self.angle = math.rad(angle)
	self.quad = love.graphics.newQuad(0, 0, w, h, atlas:getDimensions())
	self.tintColor = color or {255,255,255,255}
end

function Sprite:animate(animName)
	if self.currentAnim ~= animName and self.animations[animName] ~= nil then
		self.currentAnim = animName
		self.animations[animName]:reset()
		self.animations[animName]:set(self.quad)
	end
end

function Sprite:flipX(flip)
	if flip then
		self.flip.x = -1
	else 
		self.flip.x = 1
	end
end

function Sprite:flipY(flip)
	if flip then
		self.flip.y = -1
	else 
		self.flip.y = 1
	end
end

function Sprite:animationFinished()
	if self.animations[self.currentAnim] ~= nil then
		return self.animations[self.currentAnim].done
	end
	return true
end

function Sprite:addAnimations(animations)
	assert(type(animations) == "table", "animations paramater must be a table!")
	for k, v in pairs(animations) do
		self.animations[k] = v
	end
end

function Sprite:update(dt)
	if self.animations[self.currentAnim] ~= nil then
		self.animations[self.currentAnim]:update(dt, self.quad)
	end
end

function Sprite:draw()
	love.graphics.setColor(self.tintColor)
	love.graphics.draw(self.atlas, self.quad, self.pos.x, self.pos.y, self.angle, self.scale.x * self.flip.x, self.scale.y * self.flip.y, self.w / 2, self.h / 2)
end

return Sprite